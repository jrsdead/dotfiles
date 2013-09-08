#!/bin/bash

setup_total_terminal(){

	if [[ "$OSTYPE" =~ ^darwin ]]; then
		cd ${HOME}/dotfiles/setup
		curl -L -o TotalTerminal-1.3.dmg "http://downloads.binaryage.com/TotalTerminal-1.3.dmg"
		hdiutil attach TotalTerminal-1.3.dmg
		sudo installer -pkg /Volumes/TotalTerminalTotalTerminal.pkg -target /
		hdiutil detach /Volumes/TotalTerminal
	fi
}	