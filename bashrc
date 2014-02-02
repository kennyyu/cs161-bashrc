# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
    . /etc/bashrc
fi

# Source cs161-dotfiles definitions
source ~/cs161-dotfiles/git-prompt.sh
source ~/cs161-dotfiles/aliases.sh
export GIT_PS1_SHOWDIRTYSTATE=1

# Colors
RESET="\[\017\]"
NORMAL="\[\033[0m\]"
RED="\[\033[31;1m\]"
YELLOW="\[\033[33;1m\]"
WHITE="\[\033[37;1m\]"

# User specific aliases and functions
PATH="$HOME"/cs161/sys161/bin:"$HOME"/cs161/sys161/tools/bin:$PATH

# Change shell prompt
export PS1='\[$(tput bold)\]\[$(tput setaf 2)\][\u@\h \w\[$(tput setaf 5)\]$(__git_ps1 " (%s)")\[$(tput setaf 2)\]]\$\[$(tput sgr0)\] '
