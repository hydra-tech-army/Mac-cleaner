#!/bin/bash

echo "🧼 Hydra's Cleaner: Full System Cleanup & Refresh Mode 🧬"

read -p "⚠️ This will clean and rename volumes safely. Proceed? (y/n): " confirm
[[ "$confirm" != "y" ]] && echo "❌ Cancelled." && exit 1

# 1. Clean up user/system junk
echo "🧽 Cleaning caches, logs, and temp files..."
sudo rm -rf ~/Library/Caches/* /Library/Caches/* /private/var/folders/*
sudo rm -rf ~/Library/Logs/* /var/log/* /Library/Logs/*

# 2. Update system and Homebrew tools
echo "🔄 Updating system..."
softwareupdate -ia --verbose
if ! command -v brew &>/dev/null; then
  echo "📦 Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi
brew update && brew upgrade

# 3. Rename visible APFS volumes to "New Machine" (skip hidden/system ones)
echo "📝 Renaming user-visible APFS volumes..."
diskutil list | grep "APFS Volume" | awk -F ': ' '{print $2}' | while read -r vol; do
  [[ "$vol" =~ "Preboot" || "$vol" =~ "Recovery" || "$vol" =~ "VM" || "$vol" =~ "Update" ]] && continue
  echo "Renaming $vol..."
  sudo diskutil rename "$vol" "New Machine" 2>/dev/null
done

# 4. UI tweaks - safe and reversible
echo "🎨 Tweaking UI..."
defaults write com.apple.finder AppleShowAllFiles -bool true
defaults write com.apple.finder _FXShowPosixPathInTitle -bool true
defaults write NSGlobalDomain AppleInterfaceStyleSwitchesAutomatically -bool true
defaults write com.apple.finder ShowRecentTags -bool false
killall Finder

defaults write com.apple.dock autohide -bool true
defaults write com.apple.dock autohide-time-modifier -float 0.1
defaults write com.apple.dock expose-animation-duration -float 0.1
killall Dock

# Set default wallpaper (built-in)
osascript -e 'tell application "Finder" to set desktop picture to POSIX file "/System/Library/Desktop Pictures/Big Sur Graphic.heic"'

# 5. Install essentials (optional)
brew install --cask iterm2 rectangle visual-studio-code

# 6. Final message
echo ""
echo "💀 Computer cleared. Thanks for using Hydra's Cleaner."
