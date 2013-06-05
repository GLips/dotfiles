# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# User specific aliases and functions
UNAME=`uname -s`

# Source all files in the ~/.bash/ directory
for f in ~/.bash/*; do 
	echo "sourcing $f"
	source $f;
done

# Set PS1
case "$TERM" in xterm*)
	NOCOLOR="\[\e[m\]"
	CWDCOLOR="\[\e[36m\]"
	PRMTCOLOR="\[\e[32m\]"
	USERCOLOR="\[\e[1;41;37m\]"
	BARCOLOR="\[\e[1;41;31m\]"
esac
TITLE="\[\e]0;\u@\h\a\]"
PS1="${TITLE}${CWDCOLOR}\W${PRMTCOLOR}"
PS1="${BARCOLOR}(${USERCOLOR}\u${BARCOLOR})${NOCOLOR} ${PS1}"
if [[ $EUID -ne 0 ]]; then
	PS1="${PS1}>"
else
	PS1="${PS1}#"
fi
PS1="${PS1}${NOCOLOR} "

PATH=$PATH:$HOME/.rvm/bin # Add RVM to PATH for scripting
shopt -s expand_aliases
set -o vi

export HISTFILESIZE=10000
