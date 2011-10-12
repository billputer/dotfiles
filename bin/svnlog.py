#!/usr/bin/env python
# encoding: utf-8
"""
svnlog

Show a log of SVN revisions. Similar to (and indeed wrapping) svn log, but with extra filtering and output options.

Requires Python 2.5 or later and the dateutils package.

Created by Simon Brunning on 2007-11-13.
"""

from optparse import OptionParser, OptionGroup, OptionValueError
from xml.parsers.expat import ExpatError
import codecs
import datetime
import locale
import logging
import os, sys
import re
import subprocess
import warnings
import xml.etree.ElementTree as ET
try:
    import dateutil.parser
    import dateutil.tz
except ImportError:
    print """You need the dateutils package to run this command. Install with:\neasy_install dateutil"""
    raise

script_name = os.path.basename(sys.argv[0])
usage = script_name + ' [options] [path(s)]'
description = '''
Show a log of SVN revisions to specified paths. Similar to svn log, but with extra filtering and output options.
'''
version="1.2"

logger = logging.getLogger(script_name)

ISO8601_FORMAT = "%Y-%m-%dT%H:%M:%S"
DATE_DISPLAY_FORMAT = "%I:%M:%S %p, %A %d/%m/%Y"
DATE_DISPLAY_FORMAT_WITH_TZ = "%I:%M:%S %p %Z, %A %d/%m/%Y"
REVISION_TEMPLATE = '''------------------------------------------------------------------------
r%(revision)s | %(author)s | %(displaydate)s | %(path_count)s file%(paths_plural)s modified

%(paths)s%(message)s
'''
TODAY = datetime.date.today()
YESTERDAY = TODAY - datetime.timedelta(1)
TODAY_STRING = TODAY.strftime('{%Y-%m-%d}')
YESTERDAY_STRING = YESTERDAY.strftime('{%Y-%m-%d}')

def main(argv=None):
    options, script, paths = get_options(argv or sys.argv)
    init_logger(options.verbosity)
    
    svnlog = SvnLog(paths, **options.__dict__)
           
    if options.format == "H":
        svnlog.print_revisions(options.invert, options.detail, options.timezone)
    elif options.format == "C":
        svnlog.print_revisions_comma_separated(options.invert)
    elif options.format == "X":
        svnlog.print_xml_revisions(options.invert, options.detail, options.timezone)
    else:
        logger.error("Invalid format option %s", options.format)
        
class SvnLog(object):
    """Log of Subversion revisions."""
    def __init__(self,
           paths,
           author_filter=None,
           message_filter=None,
           path_filter=None,
           range_filter=None,
           limit=None,
           operation_filter=None,
           stop_on_copy=False,
           *args, **kwargs):
        super(SvnLog, self).__init__()
        
        self.paths = paths or ['.']
        self.author_filter=author_filter
        self.message_filter=message_filter
        self.path_filter=path_filter
        self.range_filter=range_filter
        self.limit=limit
        self.operation_filter=operation_filter
        self.stop_on_copy=stop_on_copy
        
        self.fix_range_filter()
        self.repository_urls = self.get_repository_urls()
        self.revisions = self.get_revisions()
        
    def fix_range_filter(self):
        '''Replace special values (such as TODAY) in the range filter with the values SVN will understand.'''
        if self.range_filter:
            self.range_filter = self.range_filter.upper()
            if self.range_filter == 'TODAY':
                self.range_filter = 'TODAY:HEAD'
            for framval, toval in [('TODAY', TODAY_STRING), ('YESTERDAY', YESTERDAY_STRING)]:
                self.range_filter = self.range_filter.replace(framval, toval)
                logger.debug("Range filter set to %s", self.range_filter)

    def get_repository_urls(self):
        '''Get SVN repository URLs for local paths'''
        for local_path in self.paths:
            svnargs = ["svn", "info", "--xml", local_path]
        
            logger.info('Running command "%s"', " ".join(svnargs))
            process = subprocess.Popen(svnargs, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
            stdout, stderr = process.communicate()
        
            if stderr:
                raise SvnException(stderr)
        
            try:
                info_tree = ET.XML(stdout)
            except ExpatError, exception:
                raise SvnException("Can't parse 'svn info' output: " + stdout)
            
            url = info_tree.findtext('*/url')
            logger.debug('Got url "%s"', url)
            yield url

    def get_revisions(self):
        revisions = list()
        for repository_url in self.repository_urls:
            revisions_tree = self.run_svn_log(repository_url)
            revisions += self.extract_revisions_from_tree(revisions_tree)
        return revisions

    def run_svn_log(self, repository_url):
        '''Constuct args for 'svn log' command, run it, and return result.''' 
        svnargs = ["svn", "log", "--xml", '-v']
        if self.limit: svnargs += ["--limit", str(self.limit)]
        if self.range_filter: svnargs += ['-r' + self.range_filter]
        if self.stop_on_copy: svnargs += ["--stop-on-copy"]
        svnargs += [repository_url]
    
        logger.info('Running command "%s"', " ".join(svnargs))
        process = subprocess.Popen(svnargs, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
        stdout, stderr = process.communicate()
        if stderr:
            raise SvnException(stderr)
        return self.build_revisions_tree_from_xml(stdout)

    def build_revisions_tree_from_xml(self, xml):
        '''Either return a valid revisions tree, or die trying.'''
        try:
            revisions_tree = ET.XML(xml)
        except ExpatError, exception:
            raise SvnException("Can't parse 'svn log' output: " + xml)
            
        return revisions_tree

    def extract_revisions_from_tree(self, revisions_tree):
        '''Convert revisions tree into a list of revision objects'''
        revisions = list(self.extract_revision_details(revision)
                        for revision
                        in revisions_tree)
        revisions = list(revision
                        for revision
                        in revisions            
                        if not self.unwanted_revision(revision))
        return revisions

    def extract_revision_details(self, revision_node):
        '''Extract revision details from revision XML node.'''
        revision = int(revision_node.attrib['revision'])
        author = revision_node.findtext('author')
        changedate = dateutil.parser.parse(revision_node.findtext('date'))
        message = revision_node.findtext('msg')
        paths = list((path.attrib['action'], path.text) for path in revision_node.find('paths'))
        path_count = len(paths)
    
        return Revision(revision=revision, author=author, changedate=changedate, message=message, paths=paths, path_count=path_count)

    def unwanted_revision(self, revision):
        '''Is this an unwanted revision?'''
        return self.author_filter and not re.search(self.author_filter, revision.author, re.IGNORECASE) \
            or self.message_filter and not re.search(self.message_filter, revision.message, re.IGNORECASE) \
            or self.path_filter and not any(re.search(self.path_filter, path[-1], re.IGNORECASE) for path in revision.paths) \
            or self.operation_filter and not any(path[0] in self.operation_filter for path in revision.paths)
     
    def print_revisions(self, invert, detail, timezone, stream=sys.stdout):
        '''Print revision details in text format.'''
        stream = wrap_stream_for_tty(stream)
        for revision in self.revisions_in_order(invert):
            revision.paths = "".join(("%s\t%s\n" % path) for path in (sorted(revision.paths, key=lambda x: x[-1]))) if detail else ""
            revision.paths_plural = "s" if revision.path_count > 1 else ""
        
            displaydate = revision.changedate.astimezone(dateutil.tz.tzlocal()) if timezone.lower() == 'l' else revision.changedate
            revision.displaydate = displaydate.strftime(DATE_DISPLAY_FORMAT if timezone.isupper() else DATE_DISPLAY_FORMAT_WITH_TZ)
        
            print >> stream, REVISION_TEMPLATE % revision
            
    def print_revisions_comma_separated(self, invert):
        '''Print comma separated list of revisions.'''
        print ','.join(str(revision.revision) for revision in self.revisions_in_order(invert))
       
    def revisions_in_order(self, invert):
        return sorted(self.revisions, key=lambda revision: revision.revision, reverse=not invert)
        
def wrap_stream_for_tty(stream):
    if stream.isatty():
        # Configure locale from the user's environment settings.
        locale.setlocale(locale.LC_ALL, '')

        # Wrap stdout with an encoding-aware writer.
        lang, encoding = locale.getdefaultlocale()
        logger.debug('Streaming to tty with lang %s, encoding %s', lang, encoding)
        if encoding:
            return codecs.getwriter(encoding)(stream)
        else:
            logger.warn('No tty encoding found!')

    return stream
    
class Bunch(object):
    '''General purpose container.
    See http://aspn.activestate.com/ASPN/Cookbook/Python/Recipe/52308
    '''
    def __init__(self, **kwds):
        self.__dict__.update(kwds)
        
    def __getitem__(self, key):
        return self.__dict__[key]
        
    def __str__(self):
        state = ("%s=%r" % (attribute, value)
                 for (attribute, value)
                 in self.__dict__.iteritems())
        return '\n'.join(state)
        
class Revision(Bunch):
    pass
    
class SvnException(Exception):
    """SVN execution exception"""
    def __init__(self, message):
        super(SvnException, self).__init__()
        self.message = message
        
    # def _get_message(self, message): return self._message
    # def _set_message(self, message): self._message = message
    # message = property(_get_message, _set_message)
        
    def __str__(self):
        return self.message

def init_logger(verbosity, stream=sys.stdout):
    '''Initialize logger and warnings according to verbosity argument.
    verbosity levels of 0-3 supported'''
    is_not_debug = verbosity <= 2
    level = [logging.ERROR, logging.WARNING, logging.INFO][verbosity] if is_not_debug else logging.DEBUG
    format = '%(message)s' if is_not_debug else '%(asctime)s %(levelname)-8s %(name)s %(module)s.py:%(funcName)s():%(lineno)d %(message)s'
    logging.basicConfig(level=level, format=format, stream=stream)
    if is_not_debug: warnings.filterwarnings('ignore')
        
def check_multiple_valid_option_values(option, opt_str, value, parser, **kwargs):
    '''OptionParser callback to check that an option consists only of specified values - but it can consist of a number of them.
    Requires a callback_kwargs mapping containing a value for 'valid_values' to be passed to the option.'''
    valid_values = kwargs['valid_values']
    for operation in value:
        if operation not in valid_values:
            raise OptionValueError("%s option %s invalid - must consist only of a number of: %s." % (option, value, ', '.join(valid_values)))
    setattr(parser.values, option.dest, value)

def get_options(argv):
    parser = OptionParser(usage=usage, version=version)
    parser.description=description
    
    parser.add_option("-v", "--verbosity", action="count", default=0,
            help="Specify up to three times to increase verbosity, i.e. -v to see warnings, -vv for information messages, or -vvv for debug messages.")
    
    filter_group = OptionGroup(parser, "Filter Options", "Options to filter the revisions included in the output.")
    filter_group.add_option("-a", "--author", dest="author_filter", metavar="AUTHOR",
            help="Filter by author - report only this author's revisions.")
    filter_group.add_option("-m", "--message", dest="message_filter", metavar="MESSAGE",
            help="Filter by message - report on only revisions with messages matching this case-insensitive regex.")
    filter_group.add_option("-p", "--path", dest="path_filter",  metavar="PATH",
            help="Filter by path - report on only revisions with updates to directories or fully-qualified file names matching this case-insensitive regex.")
    filter_group.add_option("-r", "--range", dest="range_filter", metavar="RANGE",
            help="Range - range of revisions to report - e.g. -r400:456. Can be either by revision number, date in {YYYY-MM-DD} format, or by special value such as HEAD, BASE, PREV, TODAY or YESTERDAY. TODAY can also be used by itself to show only today's checkins.")
    filter_group.add_option("-l", "--limit", type="int", default=10, metavar="LIMIT",
            help="Limit - Look at only this many revisions. (Note that the limit is applied *before* some other filtering options, so you may end up seeing fewer revisions than you specify here.) Defaults to %default. Set to 0 for no limit.")
    filter_group.add_option("-o", "--operation", dest="operation_filter", type="str", metavar="OPERATION",
            action="callback", callback=check_multiple_valid_option_values, callback_kwargs={'valid_values': 'AMD'},
            help="Filter by file operation - report on only revisions where the specified file operations (A, M or D) have been performed on the specified paths.")
    filter_group.add_option("-s", "--stop-on-copy", action="store_true",
            help="Stop on copy - don't show revisions from before current branch was taken.")
    parser.add_option_group(filter_group)

    output_group = OptionGroup(parser, "Output Options", "Options to specify the content and format of the output.")
    output_group.add_option('-f', '--format', choices=(list('HCX')), default="H",
            help="Output format. One of H (humane), C (comma separated) or X (XML). Defaults to %default.")
    output_group.add_option("-d", "--detail", action="store_true",
            help="Detail - display details of individual files and directories modified.")
    output_group.add_option("-i", "--invert", action="store_true",
            help="Invert - show revisions in reverse order, i.e. oldest first. Useful if you aren't piping the output into less.")
    output_group.add_option("-t", "--timezone", choices=(list('lsLS')), default="L", metavar="ZONE",
            help="Timezone - Timezone to use for display. One of l (local), s (server), L (local, omit), or S (server, omit). Defaults to %default.")
    parser.add_option_group(output_group)
    
    options, args = parser.parse_args(argv)
    script, args = args[0], args[1:]
    
    return options, script, args

if __name__ == "__main__":
    sys.exit(main())