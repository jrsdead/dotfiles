alias cpfolder='cp -Rpv'
alias df='df -h'
alias ducks='du -cksh * | sort -rn|head -11'
alias h='history'
alias la='ls -la'
alias ll='ls -hl'
alias lla='ls -lah'
alias ls='ls -G'
alias m='more'
alias mirror_website='wget -m -x -p --convert-links --no-host-directories --no-cache -erobots=off'
alias pg='/bin/ps aux | grep'
alias processes_all='ps -Afjv'
alias profileme="history | awk '{print $2}' | awk 'BEGIN{FS=\"|\"}{print $1}' | sort | uniq -c | sort -n | tail -n 20 | sort -nr"
alias reloadbash='source ~/.bash_profile'
alias rsync_mirror='rsync -avh --numeric-ids'
alias systail='tail -f /var/log/system.log'
alias top='top -o cpu'
alias untar='tar xfvz'
#alias lessc='/usr/local/share/npm/bin/lessc'
alias rmdsstore='sudo find / -name ".DS_Store" -depth -exec rm {} \;'

downforme () 
{ 
    RED='\e[1;31m';
    GREEN='\e[1;32m';
    YELLOW='\e[1;33m';
    NC='\e[0m';
    if [ $# = 0 ]; then
        echo -e "${COLOR_YELLOW}usage:${COLOR_NC} downforme website_url";
    else
        JUSTYOUARRAY=(`lynx -dump http://downforeveryoneorjustme.com/$1 | grep -o "It's just you"`);
        if [ ${#JUSTYOUARRAY} != 0 ]; then
            echo -e "${COLOR_RED}It's just you. \n${COLOR_NC}$1 is up.";
        else
            echo -e "${COLOR_GREEN}It's not just you! \n${COLOR_NC}$1 looks down from here.";
        fi;
    fi
}

extract () 
{ 
    if [ -f $1 ]; then
        case $1 in 
            *.tar.bz2)
                tar xvjf $1
            ;;
            *.tar.gz)
                tar xvzf $1
            ;;
            *.bz2)
                bunzip2 $1
            ;;
            *.rar)
                unrar x $1
            ;;
            *.gz)
                gunzip $1
            ;;
            *.tar)
                tar xvf $1
            ;;
            *.tbz2)
                tar xvjf $1
            ;;
            *.tgz)
                tar xvzf $1
            ;;
            *.zip)
                unzip $1
            ;;
            *.Z)
                uncompress $1
            ;;
            *.7z)
                7z x $1
            ;;
            *)
                echo "'$1' cannot be extracted via >extract<"
            ;;
        esac;
    else
        echo "'$1' is not a valid file";
    fi
}

findhosts () 
{ 
    nmap -sP -n -oG - "$1"/24 | grep "Up" | awk '{print $2}' -;
    echo "To scan those do: nmap $1-254";
    echo "To scan and OS detect those do: sudo nmap -O $1-254";
    echo "To intensly scan one do: sudo nmap -sV -vv -PN $1"
}

f () 
{ 
    ack -i -g ".*$*[^\/]*$" | highlight blue ".*/" green "$*[^/]"
}

g () 
{ 
    ack "$*" --color-match=green --color-filename=blue --smart-case
}

monitor_traffic () 
{ 
    sudo ngrep -W byline -qld en1 "$1"
}

myip () 
{ 
    lynx -dump -hiddenlinks=ignore -nolist http://checkip.dyndns.org:8245/ | awk '{ print $4 }' | sed '/^$/d; s/^[ ]*//g; s/[ ]*$//g'
}

