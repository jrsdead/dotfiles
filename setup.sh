#!/bin/bash

echo 'General Environment Setup'

# Ask for the administrator password upfront
sudo -v

# Keep-alive: update existing `sudo` time stamp until script has finished
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &


# Globals
# ----------------------------------------------------------
export OSTYPE=`uname -s | sed -e 's/  */-/g;y/ABCDEFGHIJKLMNOPQRSTUVWXYZ/abcdefghijklmnopqrstuvwxyz/'`
GITHUB_USER="jrsdead"
DOTFILES_DIRECTORY="${HOME}/dotfiles"
DOTFILES_TARBALL_PATH="https://github.com/${GITHUB_USER}=/dotfiles/tarball/master"
DOTFILES_GIT_REMOTE="https://github.com/${GITHUB_USER}=/dotfiles"

# If missing, download and extract the dotfiles repository
if [[ ! -d ${DOTFILES_DIRECTORY} ]]; then
	printf "$(tput setaf 7)Downloading dotfiles...\033[m\n"
	mkdir ${DOTFILES_DIRECTORY}
	# Get the tarball
	curl -fsSLo ${HOME}/dotfiles.tar.gz ${DOTFILES_TARBALL_PATH}
	# Extract to the dotfiles directory
	tar -zxf ${HOME}/dotfiles.tar.gz --strip-components 1 -C ${DOTFILES_DIRECTORY}
	# Remove the tarball
	rm -rf ${HOME}/dotfiles.tar.gz
fi

cd ${DOTFILES_DIRECTORY}
for file in setup/*; do
	source $file
done

# Ensure that we can actually, like, compile anything.
if [[ ! "$(type -P gcc)" && "$OSTYPE" =~ ^darwin ]]; then
	e_error "The XCode Command Line Tools must be installed first."
	exit 1
fi

# If Git is not installed...
if [[ ! "$(type -P git)" ]]; then
	# OSX
	if [[ "$OSTYPE" =~ ^darwin ]]; then
		# It's easiest to get Git via Homebrew, so get that first.
		if [[ ! "$(type -P brew)" ]]; then
			e_header "Installing Homebrew"
			true | /usr/bin/ruby -e "$(/usr/bin/curl -fsSL https://raw.github.com/mxcl/homebrew/master/Library/Contributions/install_homebrew.rb)"
		fi
		# If Homebrew was installed, install Git.
		if [[ "$(type -P brew)" ]]; then
			e_header "Updating Homebrew"
			brew update
			e_header "Installing Git"
			brew install git
		fi
	# Ubuntu.
	elif [[ "$(cat /etc/issue 2> /dev/null)" =~ Ubuntu ]]; then
		# Git is fairly easy.
		e_header "Installing Git"
		sudo apt-get -qq install git-core
	fi
# If we're still using Apple installed Git, update
else
	if  git --version | grep -n 'Apple' > /dev/null; then
		e_header "Updating Homebrew..."
		brew update
		e_header "Installing git..."
		brew install git
	fi
fi

setup_bash
setup_php
setup_total_terminal
setup_dropbox

#
if [[ "$OSTYPE" =~ ^darwin ]]; then
	e_header "Updating Homebrew..."
	brew update
	e_header "Installing lftp..."
	brew install lftp
	e_header "Installing GNU Stow..."
	brew install stow
elif [[ "$(cat /etc/issue 2> /dev/null)" =~ Ubuntu ]]; then
	e_header "Updating apt..."
	sudo apt-get update
	sudo apt_get upgrade
	e_header "Installing GNU Stow..."
	sudo apt-get install stow
fi
e_header "Installing dotfiles"
stow bash
stow scripts