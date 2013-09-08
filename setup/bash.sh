#!/bin/bash

setup_bash(){

	if [[ "$OSTYPE" =~ ^darwin ]]; then
		# Text for < Bash 4
		# Apple grep will not properly test BASHVERSIONINFO
		# We look for some other sign that we're not using Bash 4
		if ! bash --version | grep -n 'License' > /dev/null; then
		
			e_header "Updating Homebrew..."
			# Use the latest version of Homebrew
			brew update
			[[ $? ]] && e_success "Done"
			
			e_header "Updating any existing Homebrew formulae..."
			# Upgrade any already-installed formulae
			brew upgrade
			[[ $? ]] && e_success "Done"
			
			# Install Bash
			e_header "Installing bash 4..."
			brew install bash
			[[ $? ]] && e_success "Done"
			e_header "Installing bash-completion..."
			brew install bash-completion
			[[ $? ]] && e_success "Done"
			
			# Add bash to list of shells
			e_header "Adding bash to the list of shells"
			sudo bash -c "echo /usr/local/bin/bash >> /private/etc/shells"
			e_header "Changing shell"
			chsh -s /usr/local/bin/bash
			[[ $? ]] && e_success "Done"
			
			# Make bin, if it's not available. It really should be though.
			if ! directory_exists "${HOME}/bin"; then
				e_header "Creating ~/bin"
				mkdir "${HOME}/bin"
				[[ $? ]] && e_success "Done"
			fi
			
			# Symlink bash to bin
			e_header "Symlink bash to bin"
			ln -s "/usr/local/Cellar/bash/4.2.45/bin/bash" ${HOME}/bin/bash
			[[ $? ]] && e_success "Done"
		fi
	fi

}