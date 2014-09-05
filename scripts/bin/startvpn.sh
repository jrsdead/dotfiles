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

/usr/bin/osascript <<-EOF

tell application "Tunnelblick"
	connect "strongvpn"
	get state of first configuration where name = "strongvpn"
	repeat until result = "CONNECTED"
		delay 1
		get state of first configuration where name = "strongvpn"
	end repeat
end tell
EOF

echo "Your IP is now "
lynx -dump -hiddenlinks=ignore -nolist http://checkip.dyndns.org:8245/ | awk '{ print $4 }' | sed '/^$/d; s/^[ ]*//g; s/[ ]*$//g'

if ask "Start Apps?" Y; then
	if ask "Start General Apps?" Y; then
		if ask "Start Textual IRC Client?" Y; then
			echo "starting Textual"
			/usr/bin/osascript <<-ENDRUNTEXTUAL
			tell application "Textual"
			        activate
			end tell
			tell application "Terminal"
				activate
			end tell
			ENDRUNTEXTUAL
		fi
		if ask "Start Chrome?" Y; then
			echo "starting Chrome"
			/usr/bin/osascript <<-ENDRUNCHROME
			tell application "Google Chrome"
			        activate
				set theUrl to "https://awesome-hd.net"
		
				if (count every window) = 0 then
					make new window
				end if
			
				set found to false
				set theTabIndex to -1
				repeat with theWindow in every window
					set theTabIndex to 0
					repeat with theTab in every tab of theWindow
						set theTabIndex to theTabIndex + 1
						if theTab's URL = theUrl then
							set found to true
							exit
						end if
					end repeat
				
					if found then
						exit repeat
					end if
				end repeat
			
				if found then
					tell theTab to reload
					set theWindow's active tab index to theTabIndex
					set index of theWindow to 1
				else
					tell window 1 to make new tab with properties {URL:theUrl}
				end if
			end tell
			tell application "Terminal"
				activate
			end tell
			ENDRUNCHROME
		fi
	fi
	if ask "Start Dev Apps?" Y; then
		if ask "Start Coda 2?" Y; then
			echo "starting Coda 2"
			/usr/bin/osascript <<-ENDCODA
			tell application "Coda 2"
			        activate
			end tell
			tell application "Terminal"
				activate
			end tell
			ENDCODA
		fi
		if ask "Start PHPStorm?" Y; then
			echo "starting PHPStorm"
			/usr/bin/osascript <<-ENDPHPSTORM
			tell application "PhpStorm"
			        activate
			end tell
			tell application "Terminal"
				activate
			end tell
			ENDPHPSTORM
		fi
		if ask "Start PyCharm?" Y; then
			echo "starting PHPStorm"
			/usr/bin/osascript <<-ENDPYCHARM
			tell application "PyCharm"
			        activate
			end tell
			tell application "Terminal"
				activate
			end tell
			ENDPYCHARM
		fi
		if ask "Start AppCode?" Y; then
			echo "starting AppCode"
			/usr/bin/osascript <<-ENDAPPCODE
			tell application "AppCode"
			        activate
			end tell
			tell application "Terminal"
				activate
			end tell
			ENDAPPCODE
		fi
	fi
else
	echo "All Finished"
fi
