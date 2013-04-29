# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# User specific aliases and functions
PATH=$PATH:$HOME/.rvm/bin # Add RVM to PATH for scripting
shopt -s expand_aliases
set -o vi

export CP="graham@dev.customerparadigm.com:/home/graham/public_html"
export CG="captiongenerator.com@captiongenerator.com"
export IS="ironswin@ironswine.com"

alias ll="ls -laGF"
alias defend="bundle exec guard"
alias grep="grep --color=auto"
alias g="git"
