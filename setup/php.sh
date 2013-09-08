#!/bin/bash

setup_php(){

	if [[ "$OSTYPE" =~ ^darwin ]]; then
		if type -P 'brew' > /dev/null; then
			echo "Updating Homebrew..."
			brew update
			brew upgrade
			
			if [[ -f ${HOME}/.pearrc ]]; then
				echo "Backing up .pearrc..."
				mv ${HOME}/.pearrc ${HOME}/.pearrc_backup
			fi
			
			echo "Installing PHP55..."
			brew tap homebrew/dupes
			brew tap josegonzalez/homebrew-php
			brew install php55
			
			echo "Cleaning up..."
			brew cleanup
		fi
	fi
}