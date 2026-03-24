#!/bin/bash
# Focus an existing window matching app_id or launch the command
# Usage: ./niri-focus-or-open.sh <app_id_regex> <launch_command> [title _regex]

APP_ID_REGEX="$1"
COMMAND="$2"
TITLE_REGEX="$3" # Optional

if [ -z "$APP_ID_REGEX" ] || [ -z "$COMMAND" ]; then
  echo "Usage: $0 <app_id_regex> <launch_command> [title_regex]"
  exit 1
fi

# Ensure NIRI_SOCKET is available
if [ -z "$NIRI_SOCKET" ]; then
  export NIRI_SOCKET=$(ls /run/user/$(id -u)/niri-* 2>/dev/null | head -n 1)
fi

# Find window and focus
WINDOW_ID=$(niri msg -j windows | jq -r \
  --arg app_id "$APP_ID_REGEX" \
  --arg title "$TITLE_REGEX" \
  '.[] | select((.app_id | test($app_id)) and (if $title == "" then true else (.title | test($title)) end)) | .id' \
  | head -n 1)
if [ -n "$WINDOW_ID" ] && [ "$WINDOW_ID" != "null" ]; then
  niri msg action focus-window --id "$WINDOW_ID"
  exit 0                 
fi

# Fallback: Launch
eval "$COMMAND &"
