#!/usr/bin/env python
# encoding: utf-8
"""
svnlog

Show a log of SVN revisions. Similar to (and indeed wrapping) svn log, but with extra filtering options.

Requires Python 2.5 or later.

Created by Simon Brunning on 2007-11-13.
"""

from optparse import OptionParser
from xml.parsers.expat import ExpatError
import datetime
import os, sys
import re
import subprocess
import xml.etree.ElementTree as ET

usage = os.path.basename(sys.argv[0]) + ' [options] [path]'
description = '''
Show a log of SVN revisions to specified path. Similar to svn log, but with extra filtering options.
'''

ISO8601_FORMAT = "%Y-%m-%dT%H:%M:%S"
REVISION_TEMPLATE = '''------------------------------------------------------------------------
r%(revision)s | %(author)s | %(date)s | %(path_count)s file%(paths_plural)s modified

%(paths)s%(message)s
'''

def svnlog(paths, author_filter=None, message_filter=None, path_filter=None, range_filter=None, limit=None, detail=False, invert=False, stop_on_copy=False):
    """Print a list of SVN revisions"""
    repository_urls = get_repository_urls(paths or ['.'])
    revisions = list()
    for repository_url in repository_urls:
        revisions_tree = run_svn_log(limit, range_filter, stop_on_copy, repository_url)
        revisions += extract_revisions_from_tree(revisions_tree, author_filter, message_filter, path_filter)
    sort_revisions(revisions, invert)
    print_revisions(revisions, detail)
    
def get_repository_urls(local_paths):
    '''Get SVN repository URLs for local paths'''
    for local_path in local_paths:
        svnargs = ["svn", "info", "--xml", local_path]
        
        xml, errors = subprocess.Popen(svnargs, stdout=subprocess.PIPE, stderr=subprocess.PIPE).communicate()
        
        if errors:
            raise SvnException(errors)
        
        try:
            info_tree = ET.XML(xml)
        except ExpatError, exception:
            raise SvnException("Can't parse 'svn info' output: " + xml)
            
        yield info_tree.findtext('*/url')

def run_svn_log(limit, range_filter, stop_on_copy, local_path):
    '''Constuct args for 'svn log' command, run it, and return result.''' 
    svnargs = ["svn", "log", "--xml", '-v']
    if limit: svnargs += ["--limit", str(limit)]
    if range_filter: svnargs += ['-r' + range_filter]
    if stop_on_copy: svnargs += ["--stop-on-copy"]
    svnargs += [local_path]
    
    xml, errors = subprocess.Popen(svnargs, stdout=subprocess.PIPE, stderr=subprocess.PIPE).communicate()
    return build_revisions_tree_from_xml(errors, xml)
        

def build_revisions_tree_from_xml(errors, xml):
    '''Either return a valid revisions tree, or die trying.'''
    if errors:
        raise SvnException(errors)
        
    try:
        revisions_tree = ET.XML(xml)
    except ExpatError, exception:
        raise SvnException("Can't parse 'svn log' output: " + xml)
            
    return revisions_tree

def extract_revisions_from_tree(revisions_tree, author_filter, message_filter, path_filter):
    '''Convert revisions tree into a list of revision objects'''
    revisions = list(extract_revision_details(revision)
                    for revision
                    in revisions_tree)
    revisions = list(revision
                    for revision
                    in revisions            
                    if not unwanted_revision(revision, author_filter, message_filter, path_filter))
    return revisions

def extract_revision_details(revision_node):
    '''Extract revision details from revision XML node.'''
    revision = revision_node.attrib['revision']
    author = revision_node.findtext('author')
    date = datetime.datetime.strptime(revision_node.findtext('date').partition('.')[0], ISO8601_FORMAT)
    message = revision_node.findtext('msg')
    paths = list((path.attrib['action'], path.text) for path in revision_node.find('paths'))
    path_count = len(paths)
    
    return Bunch(revision=revision, author=author, date=date, message=message, paths=paths, path_count=path_count)

def unwanted_revision(revision, author_filter, message_filter, path_filter):
    '''Is this an unwanted revision?'''
    
    return author_filter and not re.search(author_filter, revision.author, re.IGNORECASE) \
        or message_filter and not re.search(message_filter, revision.message, re.IGNORECASE) \
        or path_filter and not any(re.search(path_filter, path[-1], re.IGNORECASE) for path in revision.paths)
        
def sort_revisions(revisions, invert):
    revisions.sort(key=lambda revision: revision.revision, reverse=not invert)
        
def print_revisions(revisions, detail):
    '''Print revision details.'''
    
    for revision in revisions:
        revision.paths = "".join(("%s\t%s\n" % path) for path in revision.paths) if detail else ""
        revision.paths_plural = "s" if revision.path_count > 1 else ""
        print REVISION_TEMPLATE % revision

class Bunch(object):
    '''General purpose container.
    See http://aspn.activestate.com/ASPN/Cookbook/Python/Recipe/52308
    '''
    def __init__(self, **kwds):
        self.__dict__.update(kwds)
        
    def __getitem__(self, key):
        return self.__dict__[key]
        
    def __str__(self):
        state = ["%s=%r" % (attribute, value)
                 for (attribute, value)
                 in self.__dict__.items()]
        return '\n'.join(state)
    
class SvnException(Exception):
    """SVN execution exception"""
    def __init__(self, message):
        super(SvnException, self).__init__()
        self.message = message
        
    def __str__(self):
        """docstring for __str__"""
        return self.message

def get_options(argv):
    parser = OptionParser(usage=usage)
    parser.description=description
    parser.add_option("-a", "--author",
                    dest="author",
                    default=None,
                    help="Filter by author - report only this author's revisions.")
    parser.add_option("-m", "--message",
                    dest="message",
                    default=None,
                    help="Filter by message - report on only revisions with messages matching this case-insensitive regex.")
    parser.add_option("-p", "--path",
                    dest="path",
                    default=None,
                    help="Filter by path - report on only revisions with updates to directories or fully-qualified file names matching this case-insensitive regex.")
    parser.add_option("-r", "--range",
                    dest="range",
                    default=None,
                    help="Range - range of revisions to report - e.g. -r400:456. Can be either by revision number, or date in {YYYY-MM-DD} format.")
    parser.add_option("-l", "--limit",
                    dest="limit",
                    type="int",
                    default=7,
                    help="Limit - Look at only this many revisions. (Note that the limit is applied *before* some other filtering options, so you may end up seeing fewer revisions than you specify here.) Defaults to 100. Set to 0 for no limit.")
    parser.add_option("-d", "--detail",
                    dest="detail",
                    action="store_true",
                    help="Detail - display details of individual files and directories modified.")
    parser.add_option("-i", "--invert",
                    dest="invert",
                    action="store_true",
                    help="Invert - show revisions in reverse order, i.e. oldest first. Useful if you aren't piping the output into less.")
    parser.add_option("-s", "--stop-on-copy",
                    dest="stop_on_copy",
                    action="store_true",
                    help="Stop on copy - don't show revisions from before current branch was taken.")
    parser.add_option("-q", "--quiet",
                    dest="quiet",
                    action="store_true",
                    help="Quiet mode - no output.")
    parser.add_option("-v", "--verbose",
                    dest="verbose",
                    action="store_true",
                    help="Verbose mode - more output.")
    
    options, args = parser.parse_args(argv)
    script, args = args[0], args[1:]
    return options, script, args
        
def main(argv=None):
    argv = argv or sys.argv
    options, script, args = get_options(argv)
        
    svnlog(args, options.author, options.message, options.path, options.range, options.limit, options.detail, options.invert, options.stop_on_copy)

if __name__ == "__main__":
    sys.exit(main())