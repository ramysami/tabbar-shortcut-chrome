#!/bin/bash
# Native messaging host — clicks Chrome's "Collapse Tabs" button via macOS accessibility

# Consume the incoming message (length-prefixed JSON from Chrome)
read -r -n 4 _length

osascript -e '
tell application "System Events"
    tell process "Google Chrome"
        set base to group 1 of group 1 of group 1 of group 1 of window 1
        set tabEl to UI element 3 of base
        -- "Collapse Tabs" / "Expand Tabs" button in the tab strip
        click button 1 of group 1 of tabEl
    end tell
end tell
' 2>/dev/null

# Send response back to Chrome (length-prefixed JSON)
MESSAGE='{"status":"ok"}'
LENGTH=${#MESSAGE}
printf "$(printf '\\x%02x' $((LENGTH & 0xFF)) $((LENGTH >> 8 & 0xFF)) $((LENGTH >> 16 & 0xFF)) $((LENGTH >> 24 & 0xFF)))"
printf '%s' "$MESSAGE"
