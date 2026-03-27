#!/bin/bash
# Discovers accessibility elements in Chrome's toolbar
# Run this with Chrome in foreground to find the vertical tabs toggle button name

osascript -e '
tell application "System Events"
    tell process "Google Chrome"
        set output to ""
        try
            set toolbarItems to every UI element of toolbar 1 of window 1
            repeat with item_ in toolbarItems
                set output to output & "Element: " & (class of item_ as text) & " | Name: \"" & (name of item_ as text) & "\" | Description: \"" & (description of item_ as text) & "\"" & linefeed
            end repeat
        end try
        try
            set output to output & linefeed & "--- Groups in toolbar ---" & linefeed
            set groups_ to every group of toolbar 1 of window 1
            repeat with g in groups_
                set groupItems to every UI element of g
                repeat with item_ in groupItems
                    set output to output & "Group > Element: " & (class of item_ as text) & " | Name: \"" & (name of item_ as text) & "\" | Description: \"" & (description of item_ as text) & "\"" & linefeed
                end repeat
            end repeat
        end try
        return output
    end tell
end tell
'
