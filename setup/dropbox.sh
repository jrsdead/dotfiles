#!/bin/bash

setup_dropbox(){

	if [[ "$OSTYPE" =~ ^darwin ]]; then
		cd ${HOME}/dotfiles/setup
		curl -L -o dropbox.dmg "https://www.dropbox.com/download?plat=mac"
		hdiutil attach dropbox.dmg
		open "/Volumes/Dropbox Installer/Dropbox.app"
		hdiutil detach "/Volumes/Dropbox Installer"
	fi
}