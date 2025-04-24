
#!/bin/bash

# Hydra Ultra Cleanse 100 💀
# One line = one cleanup, performance, or security action

# Style
GREEN='\033[0;32m'; RED='\033[0;31m'; CYAN='\033[0;36m'; NC='\033[0m'

echo -e "${CYAN}🧨 Running Hydra Ultra Cleanse 100...${NC}"
sleep 1

read -p "⚠️ This will perform deep optimizations. Continue? (y/n): " confirm
[[ "$confirm" != "y" ]] && echo -e "${RED}Aborted.${NC}" && exit 1

echo -e "${GREEN}Let's do this...${NC}"

# File Cleanup
sudo rm -rf /Library/Caches/*
rm -rf ~/Library/Caches/*
sudo rm -rf /private/var/folders/*
rm -rf ~/.Trash/*
sudo rm -rf /Volumes/*/.Trashes
sudo rm -rf /private/var/root/.Trash/*
sudo rm -rf /Library/Logs/*
rm -rf ~/Library/Logs/*
sudo rm -rf /private/var/log/*
qlmanage -r cache
find ~/Library/Application\ Support -type d -empty -delete
find ~/Downloads -name '*.dmg' -delete
rm -rf ~/Library/Saved\ Application\ State/*
rm -rf ~/Library/Containers/com.apple.mail/Data/Library/Logs/*
rm -rf ~/Library/Preferences/com.apple.LaunchServices.plist
rm -rf ~/Library/Preferences/com.apple.spotlight.plist
sudo periodic daily
sudo periodic weekly
sudo periodic monthly
sudo dscacheutil -flushcache
killall -HUP mDNSResponder

# Performance tweaks
sudo purge
sudo update_dyld_shared_cache -force
sudo sysctl -w vm.swapusage=0
sudo sysctl -w kern.maxfiles=65536
sudo sysctl -w kern.maxproc=2048
defaults write -g NSWindowResizeTime -float 0.001
defaults write com.apple.dock autohide-delay -float 0
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false
defaults write com.apple.finder AppleShowAllFiles YES
defaults write com.apple.dashboard mcx-disabled -bool true
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
defaults write com.apple.SoftwareUpdate ScheduleFrequency -int 1

# Security enhancements
sudo spctl --master-enable
defaults write com.apple.systempreferences TMShowUnsupportedNetworkVolumes -bool false
sudo launchctl unload -w /System/Library/LaunchDaemons/com.apple.gamed.plist 2>/dev/null
defaults write com.apple.CrashReporter DialogType none
defaults write com.apple.loginwindow SHOWFULLNAME -bool true
sudo chmod 700 /usr/local/bin
sudo chmod 700 /usr/bin
sudo chmod 700 /usr/sbin
sudo chmod 700 /bin
sudo chmod 700 /sbin
sudo chmod 700 /usr/libexec
defaults write com.apple.safari IncludeDevelopMenu -bool true
defaults write com.apple.safari WebKitDeveloperExtrasEnabledPreferenceKey -bool true
sudo defaults write /Library/Preferences/com.apple.loginwindow LoginwindowText "🛡️ Protected by Hydra Cleaner 💀"
sudo nvram boot-args="nvram -c"
csrutil status &>/dev/null || echo -e "${RED}⚠️ SIP DISABLED — Consider re-enabling it for max security${NC}"

# App checks
find /Applications -type d -name '*.app' | while read app; do codesign -dv --verbose=4 "$app" 2>&1 | grep -q "Authority=" || echo -e "${RED}Unsigned app found: $app${NC}"; done
ls -l /Library/LaunchAgents
ls -l ~/Library/LaunchAgents
ls -l /Library/LaunchDaemons
find ~/Library/LaunchAgents -name "*.plist" -exec grep -i "curl\|wget\|bash\|sh" {} \; 2>/dev/null
find /Applications -name "*.app" -exec strings {} \; 2>/dev/null | grep -iE "exec|curl|wget|bash -i|reverse shell|mining"

# Network & DNS
networksetup -setv6off Wi-Fi
sudo discoveryutil mdnsflushcache
sudo killall -HUP mDNSResponder
sudo ifconfig en0 down && sudo ifconfig en0 up
scutil --dns
dscacheutil -flushcache

# QuickClean user junk
rm -rf ~/Library/Preferences/ByHost/*
rm -rf ~/Library/LaunchAgents/com.adobe.*
rm -rf ~/Library/LaunchAgents/com.google.*
rm -rf ~/Library/Application\ Support/Google/*
rm -rf ~/Library/Application\ Support/Adobe/*
rm -rf ~/Library/Caches/com.adobe.*
rm -rf ~/Library/Caches/com.google.*

# Rebuilding system dbs
killall Dock
killall Finder
killall SystemUIServer
sudo touch /var/db/.AppleSetupDone
sudo rm -rf /var/folders/*
sudo kextcache --clear-staging
sudo kextcache --rebuild-index
sudo kextcache --rebuild-volume /
diskutil verifyVolume /

# Finish
echo -e "${GREEN}✅ Hydra Ultra Cleanse complete.${NC}"
echo -e "${CYAN}Thanks for using Hydra Ultra Cleanse 100 💀 Stay faster, cleaner, stronger.${NC}"
