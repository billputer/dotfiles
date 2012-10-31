#!/usr/bin/env sh

##
# This is script with usefull tips taken from:
#   https://github.com/mathiasbynens/dotfiles/blob/master/.osx
#   https://raw.github.com/gist/2108403/hack.sh

set -v

echo "Enable full keyboard access for all controls (e.g. enable Tab in modal dialogs)"
defaults write NSGlobalDomain AppleKeyboardUIMode -int 3

echo "Enable subpixel font rendering on non-Apple LCDs"
defaults write NSGlobalDomain AppleFontSmoothing -int 2

echo "Automatically hide and show the Dock"
defaults write com.apple.dock autohide -bool true

echo "Make Dock icons of hidden applications translucent"
defaults write com.apple.dock showhidden -bool true

echo "Enable iTunes track notifications in the Dock"
defaults write com.apple.dock itunes-notifications -bool true


# echo "Always show scrollbars"
# defaults write NSGlobalDomain AppleShowScrollBars -string "Auto"

echo "Allow quitting Finder via ⌘ + Q; doing so will also hide desktop icons"
defaults write com.apple.finder QuitMenuItem -bool true

# Disable window animations and Get Info animations in Finder
# defaults write com.apple.finder DisableAllAnimations -bool true

echo "Show all filename extensions in Finder"
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

echo "Use current directory as default search scope in Finder"
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"

echo "Show Path bar in Finder"
defaults write com.apple.finder ShowPathbar -bool true

echo "Show Status bar in Finder"
defaults write com.apple.finder ShowStatusBar -bool true

echo "Expand save panel by default"
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true

echo "Expand print panel by default"
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint -bool true

echo "Enable highlight hover effect for the grid view of a stack (Dock)"
defaults write com.apple.dock mouse-over-hilte-stack -bool true

echo "Enable spring loading for all Dock items"
defaults write enable-spring-load-actions-on-all-items -bool true

echo "Show indicator lights for open applications in the Dock"
defaults write com.apple.dock show-process-indicators -bool true

# Don’t animate opening applications from the Dock
# defaults write com.apple.dock launchanim -bool false

echo "Display ASCII control characters using caret notation in standard text views"
# Try e.g. `cd /tmp; unidecode "\x{0000}" > cc.txt; open -e cc.txt`
defaults write NSGlobalDomain NSTextShowsControlCharacters -bool true

echo "Enable AirDrop over Ethernet and on unsupported Macs running Lion"
defaults write com.apple.NetworkBrowser BrowseAllInterfaces -bool true

echo "Disable disk image verification"
defaults write com.apple.frameworks.diskimages skip-verify -bool true
defaults write com.apple.frameworks.diskimages skip-verify-locked -bool true
defaults write com.apple.frameworks.diskimages skip-verify-remote -bool true

echo "Automatically open a new Finder window when a volume is mounted"
defaults write com.apple.frameworks.diskimages auto-open-ro-root -bool true
defaults write com.apple.frameworks.diskimages auto-open-rw-root -bool true
defaults write com.apple.finder OpenWindowForNewRemovableDisk -bool true

echo "Avoid creating .DS_Store files on network volumes"
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true

echo "Disable the warning when changing a file extension"
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

echo "Enable snap-to-grid for desktop icons"
/usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:arrangeBy name" ~/Library/Preferences/com.apple.finder.plist

echo "Disable the warning before emptying the Trash"
defaults write com.apple.finder WarnOnEmptyTrash -bool false

echo "Require password immediately after sleep or screen saver begins"
defaults write com.apple.screensaver askForPassword -int 1
defaults write com.apple.screensaver askForPasswordDelay -int 0

echo "Enable tap to click (Trackpad)"
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true

echo "Disable Safari’s thumbnail cache for History and Top Sites"
defaults write com.apple.Safari DebugSnapshotsUpdatePolicy -int 2

echo "Enable Safari’s debug menu"
defaults write com.apple.Safari IncludeInternalDebugMenu -bool true

echo "Make Safari’s search banners default to Contains instead of Starts With"
defaults write com.apple.Safari FindOnPageMatchesWordStartsOnly -bool false

echo "Add a context menu item for showing the Web Inspector in web views"
defaults write NSGlobalDomain WebKitDeveloperExtras -bool true

echo "Only use UTF-8 in Terminal.app"
defaults write com.apple.terminal StringEncodings -array 4

echo "Disable the Ping sidebar in iTunes"
defaults write com.apple.iTunes disablePingSidebar -bool true

echo "Disable all the other Ping stuff in iTunes"
defaults write com.apple.iTunes disablePing -bool true

echo "Make ⌘ + F focus the search input in iTunes"
defaults write com.apple.iTunes NSUserKeyEquivalents -dict-add "Target Search Field" "@F"

echo "Disable the “reopen windows when logging back in” option"
# This works, although the checkbox will still appear to be checked.
#defaults write com.apple.loginwindow TALLogoutSavesState -bool false
#defaults write com.apple.loginwindow LoginwindowLaunchesRelaunchApps -bool false

echo "Enable Dashboard dev mode (allows keeping widgets on the desktop)"
defaults write com.apple.dashboard devmode -bool true

echo "Reset Launchpad"
#[ -e ~/Library/Application\ Support/Dock/*.db ] && rm ~/Library/Application\ Support/Dock/*.db

echo "Show the ~/Library folder"
chflags nohidden ~/Library

echo "Kill affected applications"
for app in Safari Finder Dock Mail SystemUIServer; do killall "$app" >/dev/null 2>&1; done
