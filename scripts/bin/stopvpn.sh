#!/bin/bash

function ask {
    while true; do

        if [ "${2:-}" = "Y" ]; then
            prompt="Y/n"
            default=Y
        elif [ "${2:-}" = "N" ]; then
            prompt="y/N"
            default=N
        else
            prompt="y/n"
            default=
        fi

        # Ask the question
        read -p "$1 [$prompt] " REPLY

        # Default?
        if [ -z "$REPLY" ]; then
            REPLY=$default
        fi

        # Check if the reply is valid
        case "$REPLY" in
            Y*|y*) return 0 ;;
            N*|n*) return 1 ;;
        esac

    done
}

if ask "Disconnect VPN?" Y; then
	if ask "Kill Apps?" Y; then
		/usr/bin/osascript <<-KILLAPPS
		activate application "Textual"
		tell application "System Events"
			tell process "Textual"
				click menu item "Quit Textual & IRC" of menu 1 of menu bar item "Textual" of menu bar 1
				click button "Quit" of window 1
			end tell
		end tell
		tell application "Google Chrome"
			quit
		end tell
		KILLAPPS
		echo "Apps Killed"
	fi
	echo "Disconnecting"
	/usr/bin/osascript <<-EOF

	tell application "Tunnelblick"
        	disconnect all
	end tell
	EOF
	echo "Disconnected"
fi
