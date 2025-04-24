#!/bin/bash

# Hydra Safe Mac Cleaner 💀
# A safer and smarter way to clean up your Mac
# by Hydra Tech Army

LOGFILE="$HOME/Downloads/hydra_cleaner_log.txt"
DRY_RUN=false  # Set to true to simulate actions without applying

GREEN='\033[0;32m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${CYAN}💀 Starting Hydra Safe Mac Cleaner...${NC}"
echo "Log started at $(date)" > "$LOGFILE"

function safe_action() {
  local description="$1"
  local command="$2"

  echo -e "${YELLOW}$description (y/n)?${NC}"
  read -r confirm
  if [[ "$confirm" == "y" ]]; then
    echo "✔ $description" >> "$LOGFILE"
    if [[ "$DRY_RUN" == false ]]; then
      eval "$command"
    else
      echo "[Dry Run] $command" >> "$LOGFILE"
    fi
  else
    echo "✖ Skipped: $description" >> "$LOGFILE"
  fi
}

# ------------------ SAFE CLEANING TASKS ------------------

safe_action "Clean user cache" "rm -rf ~/Library/Caches/*"
safe_action "Clean user logs" "rm -rf ~/Library/Logs/*"
safe_action "Clean Safari cache" "rm -rf ~/Library/Safari/LocalStorage/* ~/Library/Caches/com.apple.Safari/*"
safe_action "Empty user Trash" "rm -rf ~/.Trash/*"
safe_action "Delete old QuickLook cache" "qlmanage -r cache"
safe_action "Flush DNS cache" "sudo dscacheutil -flushcache; sudo killall -HUP mDNSResponder"
safe_action "Run periodic system scripts" "sudo periodic daily; sudo periodic weekly; sudo periodic monthly"
safe_action "Reset Dock and Finder (UI refresh)" "killall Dock; killall Finder"
safe_action "Remove Adobe app leftovers" "rm -rf ~/Library/Application\ Support/Adobe/*"
safe_action "Remove Google Chrome data (non-essential)" "rm -rf ~/Library/Application\ Support/Google/Chrome/*"
safe_action "Check for unsigned apps" "find /Applications -type d -name '*.app' | while read app; do codesign -dv \"$app\" 2>&1 | grep -q Authority || echo \"Unsigned app: \$app\" >> \"$LOGFILE\"; done"
safe_action "List all launch agents (no deletions)" "ls ~/Library/LaunchAgents >> \"$LOGFILE\""
safe_action "List suspicious scripts in login items" "grep -i 'curl\|wget\|bash\|sh' ~/Library/LaunchAgents/*.plist >> \"$LOGFILE\" 2>/dev/null"

# ------------------ END ------------------

echo -e "${GREEN}✅ Safe cleaning complete. Log saved at:${NC} $LOGFILE"
echo -e "${CYAN}💀 Thanks for using Hydra Safe Cleaner!${NC}"

