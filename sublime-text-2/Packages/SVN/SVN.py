import sublime
import sys
import os
import traceback
import time
import re

try:
    str_cls = unicode
except (NameError):
    str_cls = str


st_version = 2
if int(sublime.version()) > 3000:
    st_version = 3

mod_reload_prefix = ''
if st_version == 3:
    mod_reload_prefix = 'SVN.'
    from imp import reload

globals_ = {}
if st_version == 3:
    globals_ = {'__name__': __name__}

need_package_control_upgrade = False
def do_import(module, names):
    return __import__(module, globals_, {}, names, 1)


reloading = {
    'happening': False,
    'shown': False
}

# We reload in reverse order to solve some issues with super()
reload_mods = []
for mod in sys.modules:
    if (mod[0:4] == 'SVN.' or mod[0:11] == 'sublimesvn.' or mod == 'sublimesvn') and sys.modules[mod] != None:
        reload_mods.append(mod)
        reloading['happening'] = True

if reloading['happening']:
    try:
        _temp_status = do_import('sublimesvn.status', ['StatusCache'])
        if hasattr(_temp_status.StatusCache, 'last_check_thread') and _temp_status.StatusCache.last_check_thread:
            _temp_status.StatusCache.last_check_thread.stop = True
        del _temp_status
    except (ImportError) as e:
        if str(e).find('bad magic number') != -1:
            need_package_control_upgrade = True
        else:
            raise

# Prevent popups during reload, saving the callbacks for re-adding later
if reload_mods:
    old_callbacks = {}
    hook_match = re.search("<class '(\w+).ExcepthookChain'>", str(sys.excepthook))
    if hook_match:
        _temp = __import__(hook_match.group(1), globals_, {}, ['ExcepthookChain'], -1)
        ExcepthookChain = _temp.ExcepthookChain
        old_callbacks = ExcepthookChain.names
    sys.excepthook = sys.__excepthook__

mods_load_order = [
    'sublimesvn',
    'sublimesvn.dpapi',
    'sublimesvn.times',
    'sublimesvn.views',
    'sublimesvn.errors',
    'sublimesvn.cmd',
    'sublimesvn.debug',
    'sublimesvn.output',
    'sublimesvn.config',
    'sublimesvn.paths',
    'sublimesvn.threads',
    'sublimesvn.input',
    'sublimesvn.proc',
    'sublimesvn.status',
    'sublimesvn.commands',
    'sublimesvn.listeners'
]

for mod in mods_load_order:
    if mod_reload_prefix + mod in reload_mods:
        reload(sys.modules[mod_reload_prefix + mod])

#succeeded_import = False
#while not succeeded_import:
#    try:
#        # First time installs sometimes suffer from import errors because the package
#        # has not fully been extracted yet
#
#        succeeded_import = True
#    except (ImportError):
#        time.sleep(0.2)

try:
    # Python 2
    from sublimesvn.commands import (
        SvnInsertViewCommand,
        SvnReplaceViewCommand,

        SvnCommandFilterCommand,
        SvnApplicableFileCommandsCommand,
        SvnApplicableFolderCommandsCommand,
        SvnApplicableWcCommandsCommand,
        SvnFindingWorkingCopyCommand,

        SvnCheckoutCommand,
        SvnMenuCheckoutCommand,

        SvnAddInteractiveCommand,
        SvnBranchCommand,
        SvnCleanupCommand,
        SvnWcCommitCommand,
        SvnCustomCommand,
        SvnDeleteInteractiveCommand,
        SvnWcDiffCommand,
        SvnWcCustomDiffCommand,
        SvnWcRemoteDiffCommand,
        SvnRerunCommand,
        SvnWcInfoCommand,
        SvnWcLogCommand,
        SvnMergeCommand,
        SvnRelocateCommand,
        SvnWcResolveTreeConflictCommand,
        SvnRevertInteractiveCommand,
        SvnWcStatusCommand,
        SvnSwitchCommand,
        SvnUnlockInteractiveCommand,
        SvnWcUpdateCommand,
        SvnWcUpdateIncludingExternalsCommand,
        SvnUpgradeCommand,

        SvnFolderAddCommand,
        SvnFolderCopyCommand,
        SvnFolderCommitCommand,
        SvnFolderDeleteCommand,
        SvnFolderDiffCommand,
        SvnFolderCustomDiffCommand,
        SvnFolderRemoteDiffCommand,
        SvnFolderIgnoreCommand,
        SvnFolderInfoCommand,
        SvnFolderLogCommand,
        SvnFolderMoveCommand,
        SvnFolderPropertiesCommand,
        SvnFolderResolvePropertyConflictCommand,
        SvnFolderResolveTreeConflictCommand,
        SvnFolderRevertCommand,
        SvnFolderStatusCommand,
        SvnFolderUnignoreCommand,
        SvnFolderUpdateCommand,
        SvnUpdateIncludingExternalsCommand,

        SvnAddCommand,
        SvnBlameCommand,
        SvnCommitCommand,
        SvnCopyCommand,
        SvnDiffCommand,
        SvnCustomDiffCommand,
        SvnRemoteDiffCommand,
        SvnDeleteCommand,
        SvnFilePickCommand,
        SvnFilePropertiesCommand,
        SvnIgnoreCommand,
        SvnInfoCommand,
        SvnLockCommand,
        SvnLogCommand,
        SvnMoveCommand,
        SvnResolveCommand,
        SvnResolvePropertyConflictCommand,
        SvnResolveTreeConflictCommand,
        SvnRevertCommand,
        SvnStatusCommand,
        SvnUnignoreCommand,
        SvnUnlockCommand,
        SvnUpdateCommand,

        SvnChangelistAddCommand,
        SvnChangelistRemoveCommand,

        SvnPropAddCommand,
        SvnPropDeleteCommand,
        SvnPropEditCommand,
        SvnPropListCommand
    )

    from sublimesvn.listeners import (SvnMessageSaveListener, SvnFocusListener)

    from sublimesvn.status import (StatusCache)
    from sublimesvn.proc import (SVN)
    from sublimesvn.errors import (NotFoundError)

    from sublimesvn import (
        debug as svn_debug,
        times as svn_times,
        paths as svn_paths,
        proc as svn_proc,
        threads as svn_threads
    )
except (ImportError):
    try:
        # Python 3
        from .sublimesvn.commands import (
            SvnInsertViewCommand,
            SvnReplaceViewCommand,

            SvnCommandFilterCommand,
            SvnApplicableFileCommandsCommand,
            SvnApplicableFolderCommandsCommand,
            SvnApplicableWcCommandsCommand,
            SvnFindingWorkingCopyCommand,

            SvnCheckoutCommand,
            SvnMenuCheckoutCommand,

            SvnAddInteractiveCommand,
            SvnBranchCommand,
            SvnCleanupCommand,
            SvnWcCommitCommand,
            SvnCustomCommand,
            SvnDeleteInteractiveCommand,
            SvnWcDiffCommand,
            SvnWcCustomDiffCommand,
            SvnWcRemoteDiffCommand,
            SvnRerunCommand,
            SvnWcInfoCommand,
            SvnWcLogCommand,
            SvnMergeCommand,
            SvnRelocateCommand,
            SvnWcResolveTreeConflictCommand,
            SvnRevertInteractiveCommand,
            SvnWcStatusCommand,
            SvnSwitchCommand,
            SvnUnlockInteractiveCommand,
            SvnWcUpdateCommand,
            SvnWcUpdateIncludingExternalsCommand,
            SvnUpgradeCommand,

            SvnFolderAddCommand,
            SvnFolderCopyCommand,
            SvnFolderCommitCommand,
            SvnFolderDeleteCommand,
            SvnFolderDiffCommand,
            SvnFolderCustomDiffCommand,
            SvnFolderRemoteDiffCommand,
            SvnFolderIgnoreCommand,
            SvnFolderInfoCommand,
            SvnFolderLogCommand,
            SvnFolderMoveCommand,
            SvnFolderPropertiesCommand,
            SvnFolderResolvePropertyConflictCommand,
            SvnFolderResolveTreeConflictCommand,
            SvnFolderRevertCommand,
            SvnFolderStatusCommand,
            SvnFolderUnignoreCommand,
            SvnFolderUpdateCommand,
            SvnUpdateIncludingExternalsCommand,

            SvnAddCommand,
            SvnBlameCommand,
            SvnCommitCommand,
            SvnCopyCommand,
            SvnDiffCommand,
            SvnCustomDiffCommand,
            SvnRemoteDiffCommand,
            SvnDeleteCommand,
            SvnFilePickCommand,
            SvnFilePropertiesCommand,
            SvnIgnoreCommand,
            SvnInfoCommand,
            SvnLockCommand,
            SvnLogCommand,
            SvnMoveCommand,
            SvnResolveCommand,
            SvnResolvePropertyConflictCommand,
            SvnResolveTreeConflictCommand,
            SvnRevertCommand,
            SvnStatusCommand,
            SvnUnignoreCommand,
            SvnUnlockCommand,
            SvnUpdateCommand,

            SvnChangelistAddCommand,
            SvnChangelistRemoveCommand,

            SvnPropAddCommand,
            SvnPropDeleteCommand,
            SvnPropEditCommand,
            SvnPropListCommand
        )

        from .sublimesvn.listeners import (SvnMessageSaveListener, SvnFocusListener)

        from .sublimesvn.status import (StatusCache)
        from .sublimesvn.proc import (SVN)
        from .sublimesvn.errors import (NotFoundError)

        from .sublimesvn import (
            debug as svn_debug,
            times as svn_times,
            paths as svn_paths,
            proc as svn_proc,
            threads as svn_threads
        )
    except (ImportError) as e:
        if str(e).find('bad magic number') != -1:
            need_package_control_upgrade = True
        else:
            raise

try:
    # This will error if the import fails
    settings = sublime.load_settings('SVN.sublime-settings')
    svn_debug.set_debug(settings.get('debug', False))
    svn_debug.set_debug_log_file(settings.get('debug_log_file', None))


    def reset_shown():
        SVN.shown_missing = {}

    settings.add_on_change('svn_binary_path', reset_shown)
    settings.add_on_change('auto_update_check_frequency', StatusCache.set_check_updates)
    StatusCache.set_check_updates()
except (NameError):
    pass

hook_match = re.search("<class '(\w+).ExcepthookChain'>", str(sys.excepthook))

if not hook_match:
    class ExcepthookChain(object):
        callbacks = []
        names = {}

        @classmethod
        def add(cls, name, callback):
            if name == 'sys.excepthook':
                if name in cls.names:
                    return
                cls.callbacks.append(callback)
            else:
                if name in cls.names:
                    cls.callbacks.remove(cls.names[name])
                cls.callbacks.insert(0, callback)
            cls.names[name] = callback

        @classmethod
        def hook(cls, type, value, tb):
            for callback in cls.callbacks:
                callback(type, value, tb)

        @classmethod
        def remove(cls, name):
            if name not in cls.names:
                return
            callback = cls.names[name]
            del cls.names[name]
            cls.callbacks.remove(callback)
else:
    _temp = __import__(hook_match.group(1), globals(), locals(),
        ['ExcepthookChain'], -1)
    ExcepthookChain = _temp.ExcepthookChain


# Override default uncaught exception handler
def svn_uncaught_except(type, value, tb):
    message = ''.join(traceback.format_exception(type, value, tb))

    if message.find('/sublimesvn/') != -1 or message.find('\\sublimesvn\\') != -1:
        def append_log():
            log_file_path = os.path.join(sublime.packages_path(), 'User',
                'SVN.errors.log')
            send_log_path = log_file_path
            timestamp = svn_times.timestamp_to_string(time.time(),
                    '%Y-%m-%d %H:%M:%S\n')
            with open(log_file_path, 'a') as f:
                f.write(timestamp)
                f.write(message)
            if svn_debug.get_debug() and svn_debug.get_debug_log_file():
                send_log_path = svn_debug.get_debug_log_file()
                svn_debug.debug_print(message)
            sublime.error_message(('Sublime SVN\n\nAn unexpected error ' +
                'occurred, please send the file %s to support@wbond.net') % (
                send_log_path))
            sublime.active_window().run_command('open_file',
                {'file': svn_paths.fix_windows_path(send_log_path)})
        if reloading['happening']:
            if not reloading['shown']:
                sublime.error_message('Sublime SVN\n\nSublime SVN was just upgraded' +
                    ', please restart Sublime to finish the upgrade')
                reloading['shown'] = True
        else:
            sublime.set_timeout(append_log, 10)

if reload_mods and old_callbacks:
    for name in old_callbacks:
        ExcepthookChain.add(name, old_callbacks[name])

ExcepthookChain.add('sys.excepthook', sys.__excepthook__)
ExcepthookChain.add('svn_uncaught_except', svn_uncaught_except)

if sys.excepthook != ExcepthookChain.hook:
    sys.excepthook = ExcepthookChain.hook

svn_binary_path = settings.get('svn_binary_path')


try:
    # This won't work if the import failed
    class SvnInit(svn_threads.HookedThread):
        def run(self):
            try:
                SVN.init(svn_binary_path=svn_binary_path)
            except (NotFoundError) as e:
                def show_not_found():
                    if SVN.shown_global_not_found:
                        return
                    SVN.shown_global_not_found = True

                    message = (u'Sublime SVN\n\nThe Subversion command line client ' +
                        u'could not be found on your machine.')
                    if int(sublime.version()) >= 2190:
                        message += u'\n\nWould you like to visit the ' + \
                            'Sublime SVN site for installation help?'
                        if sublime.ok_cancel_dialog(message, 'Yes'):
                            sublime.active_window().run_command('open_url',
                                {'url': 'http://wbond.net/sublime_packages/svn/installation#Subversion_Command_Line'})
                        else:
                            return
                    else:
                        message += u' Please visit http://sublime.wbond.net/svn/install' + \
                            u' for help.'
                        sublime.error_message(message)
                        return
                sublime.set_timeout(show_not_found, 1)

            except (OSError) as e:
                svn_path = re.sub('The binary "(.*)" does not exist.*$', '\\1', str_cls(e))
                error = str_cls(e)
                if svn_path not in SVN.shown_missing:
                    def do_show():
                        sublime.error_message(u'Sublime SVN\n\n' + error)
                    sublime.set_timeout(do_show, 1)
                    SVN.shown_missing[svn_path] = True
except (NameError):
    pass


def plugin_loaded():
    if need_package_control_upgrade:
        sublime.error_message(u'SVN\n\nThe SVN package seems to have been ' + \
            u'installed using an older version of Package Control. Please ' + \
            u'remove the SVN package, upgrade Package Control to 2.0.0 ' + \
            u'and then reinstall SVN.\n\nIt may be necessary to delete ' + \
            u'the "Packages/Package Control/" folder and then follow the ' + \
            u'instructions at https://sublime.wbond.net/installation to ' + \
            u'properly upgrade Package Control.')
    else:
        SvnInit().start()


if st_version == 2:
    plugin_loaded()


def unload_handler():
    ExcepthookChain.remove('svn_uncaught_except')
