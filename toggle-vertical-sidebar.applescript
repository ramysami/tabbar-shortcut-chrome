#!/usr/bin/osascript

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Toggle vertical sidebar
# @raycast.mode silent

# Optional parameters:
# @raycast.icon 🤖

try
    tell application "System Events"
        tell process "Google Chrome"
            if not (exists window 1) then return
            
            -- Check if window 1 is PiP
            if name of window 1 is "Picture in Picture" then
                if not (exists window 2) then return
                set targetWindow to window 2
            else
                set targetWindow to window 1
            end if
            
            set base to group 1 of group 1 of group 1 of group 1 of targetWindow
            
            click button 1 of group 1 of UI element 3 of base
        end tell
    end tell
on error
    return
end try
return