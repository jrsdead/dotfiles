if [[ $- == *i* ]] ; then
	export IS_INTERACTIVE=true
else
	export IS_INTERACTIVE=false
fi

if [[ -z $SSH_CONNECTION ]]; then
	export IS_REMOTE=false
else
	export IS_REMOTE=true
fi



# Colors ----------------------------------------------------------
export TERM=xterm-color
export GREP_OPTIONS='--color=auto' GREP_COLOR='1;32'
export CLICOLOR=1 

if [ "$OS" = "linux" ] ; then
	alias ls='ls --color=auto' # For linux, etc
	# ls colors, see: http://www.linux-sxs.org/housekeeping/lscolors.html
	export LS_COLORS='di=1:fi=0:ln=31:pi=5:so=5:bd=5:cd=5:or=31:mi=0:ex=35:*.rb=90'  #LS_COLORS is not supported by the default ls command in OS-X
else
	alias ls='ls -G'  # OS-X SPECIFIC - the -G command in OS-X is for colors, in Linux it's no groups
fi

# Setup some colors to use later in interactive shell or scripts
export COLOR_NC='\033[0m' # No Color
export COLOR_WHITE='\033[1;37m'
export COLOR_BLACK='\033[0;30m'
export COLOR_BLUE='\033[0;34m'
export COLOR_LIGHT_BLUE='\033[1;34m'
export COLOR_GREEN='\033[0;32m'
export COLOR_LIGHT_GREEN='\033[1;32m'
export COLOR_CYAN='\033[0;36m'
export COLOR_LIGHT_CYAN='\033[1;36m'
export COLOR_RED='\033[0;31m'
export COLOR_LIGHT_RED='\033[1;31m'
export COLOR_PURPLE='\033[0;35m'
export COLOR_LIGHT_PURPLE='\033[1;35m'
export COLOR_BROWN='\033[0;33m'
export COLOR_YELLOW='\033[1;33m'
export COLOR_GRAY='\033[1;30m'
export COLOR_LIGHT_GRAY='\033[0;37m'
alias colorslist="set | egrep 'COLOR_\w*'"  # lists all the colors


# History ----------------------------------------------------------
export HISTCONTROL=ignoredups
#export HISTCONTROL=erasedups
export HISTFILESIZE=3000
export HISTIGNORE="ls:cd:[bf]g:exit:..:...:ll:lla"
alias h=history
hf(){ 
	grep "$@" ~/.bash_history
}



if [ $IS_INTERACTIVE = 'true' ] ; then # Interactive shell only

	# Input stuff -------------------------------------------------------
	bind "set completion-ignore-case on" # note: bind used instead of sticking these in .inputrc
	bind "set show-all-if-ambiguous On" # show list automatically, without double tab
	bind "set bell-style none" # no bell
	
	shopt -s checkwinsize # After each command, checks the windows size and changes lines and columns
	
	
	
	# Completion -------------------------------------------------------
	
	# Turn on advanced bash completion if the file exists 
	# Get it here: http://www.caliban.org/bash/index.shtml#completion) or 
	# on OSX: sudo port install bash-completion
	if [ -f /etc/bash_completion ]; then
		. /etc/bash_completion
	fi
	if [ -f /opt/local/etc/bash_completion ]; then
		. /opt/local/etc/bash_completion
	fi
	if [ -f /etc/bash_completion ]; then
		. /etc/bash_completion
	fi
	if [ -f `brew --prefix`/etc/bash_completion ]; then
		. `brew --prefix`/etc/bash_completion
	fi
	
	# git completion
	#source ~/cl/bin/git-completion.bash
	
	# Add completion to source and .
	complete -F _command source 
	complete -F _command .
	
	
	
	# Prompts ----------------------------------------------------------
	
	# Detect whether the current directory is a git repository.
	function is_git_repository {
		git branch > /dev/null 2>&1
	}
	
	# Detect whether the current directory is a subversion repository.
	function is_svn_repository {
		test -d .svn
	}
	
	# Determine the branch/state information for this git repository.
	function set_git_branch {
		# Capture the output of the "git status" command.
		git_status="$(git status 2> /dev/null)"
		
		# Set color based on clean/staged/dirty.
		if [[ ${git_status} =~ "working directory clean" ]]; then
			state="${COLOR_GREEN}"
		elif [[ ${git_status} =~ "Changes to be committed" ]]; then
			state="${COLOR_YELLOW}"
		else
			state="${COLOR_RED}"
		fi
		
		# Set arrow icon based on status against remote.
		remote_pattern="# Your branch is (.*) of"
		if [[ ${git_status} =~ ${remote_pattern} ]]; then
			if [[ ${BASH_REMATCH[1]} == "ahead" ]]; then
				remote="↑"
			else
				remote="↓"
			fi
		else
			remote=""
		fi
		diverge_pattern="# Your branch and (.*) have diverged"
		if [[ ${git_status} =~ ${diverge_pattern} ]]; then
			remote="↕"
		fi
		
		# Get the name of the branch.
		branch_pattern="^# On branch ([^${IFS}]*)"    
		if [[ ${git_status} =~ ${branch_pattern} ]]; then
			branch=${BASH_REMATCH[1]}
		fi
		
		# Set the final branch string.
		revNo=$(git rev-parse HEAD 2> /dev/null | cut -c1-7)
		BRANCH="${state}[git:${branch}:${revNo}]${remote}${COLOR_NC} "
	}
	
	# Determine the branch information for this subversion repository. No support
	# for svn status, since that needs to hit the remote repository.
	function set_svn_branch {
		# Capture the output of the "git status" command.
		svn_info="$(svn info | egrep '^URL: ' 2> /dev/null)"
	
		# Get the name of the branch.
		branch_pattern="^URL: .*/(branches|tags)/([^/]+)"
		trunk_pattern="^URL: .*/trunk(/.*)?$"
		if [[ ${svn_info} =~ $branch_pattern ]]; then
			branch=${BASH_REMATCH[2]}
		elif [[ ${svn_info} =~ $trunk_pattern ]]; then
			branch='trunk'
		fi
	
		# Set the final branch string.
		revNo=`svnversion --no-newline`
		BRANCH="[svn:${branch}:${revNo}] "
	}
	
	# Return the prompt symbol to use, colorized based on the return value of the
	# previous command.
	function set_prompt_symbol () {
		if test $1 -eq 0 ; then
			PROMPT_SYMBOL=">"
		else
			PROMPT_SYMBOL="${COLOR_RED}>${COLOR_NC}"
		fi
	}
	
	# Set the full bash prompt.
	function set_bash_prompt () {
		# Set the PROMPT_SYMBOL variable. We do this first so we don't lose the 
		# return value of the last command.
		set_prompt_symbol $?
	
		# Set the BRANCH variable.
		if is_git_repository ; then
			set_git_branch
		elif is_svn_repository ; then
			set_svn_branch
		else
			BRANCH=''
		fi
	
		# Set the bash prompt variable.
		PS1="\[${COLOR_GREEN}\]\u@\[${COLOR_PURPLE}\]\h \[${COLOR_CYAN}\]\W\[${COLOR_NC}\] ${BRANCH}${PROMPT_SYMBOL} "
	}
	
	# Tell bash to execute this function just before displaying its prompt.
	PROMPT_COMMAND=set_bash_prompt

	#source ~/bin/git_svn_bash_prompt.sh  
	
	function xtitle {  # change the title of your xterm* window
		unset PROMPT_COMMAND
		echo -ne "\033]0;$1\007" 
	}

fi





source ~/bin/bashmarks.sh



# Editors ----------------------------------------------------------
export EDITOR='nano'  #Command line
export GIT_EDITOR='nano'


# Security ---------------------------------------------------------

# Folder shared by a group
# chmod g+s directory 
#find /foo -type f -print | xargs chmod g+rw,o-rwx,u+rw
#find /foo -type d -print | xargs chmod g+rwxs,o-rwx,u+rwx

# this might work just the same (not tested)
# chmod -R g+rwXs,o-rwx,u+rwX /foo


# Ruby ----------------------------------------------------

# RVM
[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*


# Bring in the other files ----------------------------------------------------
if [ $IS_INTERACTIVE = 'true' ] ; then
  source ~/.bashrc_help

  source ~/bin/sv.sh # SVN tools
  source ~/bin/mysql/mq.sh # MySQL tools
  source ~/bin/bashalias.sh
fi

if [ -f ~/.bashrc_local ]; then
  source ~/.bashrc_local
fi



# Test ------------------------------------------------------------------------ 

#if [ "$OS" = "linux" ] ; then
#elif
#else
#fi