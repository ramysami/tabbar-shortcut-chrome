#!/bin/bash
# Native messaging host — clicks Chrome's "Collapse Tabs" button via macOS accessibility

# Consume the incoming message (length-prefixed JSON from Chrome)
read -r -n 4 _length

osascript -e '
tell application "System Events"
    tell process "Google Chrome"
        repeat with w in (every window)
            set wName to name of w
            -- Skip PiP windows
            if wName is not "Picture in Picture" and wName does not contain "Video playing in picture-in-picture mode" then
                try
                    -- Attempt to click the toggle button in the known hierarchy.
                    -- This will only succeed on windows that actually have the vertical tab bar.
                    click button 1 of group 1 of UI element 3 of group 1 of group 1 of group 1 of group 1 of w
                    return -- Success, exit the script
                end try
            end if
        end repeat
    end tell
end tell
' 2>/dev/null

# Send response back to Chrome (length-prefixed JSON)
MESSAGE='{"status":"ok"}'
LENGTH=${#MESSAGE}
printf "$(printf '\\x%02x' $((LENGTH & 0xFF)) $((LENGTH >> 8 & 0xFF)) $((LENGTH >> 16 & 0xFF)) $((LENGTH >> 24 & 0xFF)))"
printf '%s' "$MESSAGE"
