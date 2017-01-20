#!/bin/bash
# Author: Matt Mastracci (matthew@mastracci.com)
# AppleScript from http://stackoverflow.com/questions/4309087/cancel-button-on-osascript-in-a-bash-script
# licensed under cc-wiki with attribution required 
# Remainder of script public domain

osascript -e 'tell application "iTerm2" to version' > /dev/null 2>&1 && NAME=iTerm2 || NAME=iTerm
if [[ $NAME = "iTerm" ]]; then
    FILE=`osascript -e 'tell application "iTerm" to activate' -e 'tell application "iTerm" to set thefile to choose folder with prompt "Choose a folder to place received files in"' -e "do shell script (\"echo \"&(quoted form of POSIX path of thefile as Unicode text)&\"\")"`
else
    FILE=`osascript -e 'tell application "iTerm2" to activate' -e 'tell application "iTerm2" to set thefile to choose folder with prompt "Choose a folder to place received files in"' -e "do shell script (\"echo \"&(quoted form of POSIX path of thefile as Unicode text)&\"\")"`
fi

TITLE="iTerm2 SZ transfer"

if [[ $FILE = "" ]]; then
    # Send ZModem cancel
    osascript -e "display notification \"File transfer aborted!\" with title \"${TITLE}\"" 
    echo
else
    cd "$FILE"
    if ! /usr/local/bin/rz -E -e -b; then
        osascript -e "display notification \"File transfer Failed!\" with title \"${TITLE}\"" 
    else
        osascript -e "display notification \"File transfer OK\" with title \"${TITLE}\"" 
    fi
    echo
fi
