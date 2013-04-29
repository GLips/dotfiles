# .bashrc

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
if [[ $(whoami) != "Graham" ]]; then
	PS1="${BARCOLOR}(${USERCOLOR}\u${BARCOLOR})${NOCOLOR} ${PS1}"
fi
if [[ $EUID -ne 0 ]]; then
	PS1="${PS1}>"
else
	PS1="${PS1}#"
fi
PS1="${PS1}${NOCOLOR} "

PATH=$PATH:$HOME/.rvm/bin # Add RVM to PATH for scripting
shopt -s expand_aliases
set -o vi

export CP="graham@dev.customerparadigm.com:/home/graham/public_html"
export CG="captiongenerator.com@captiongenerator.com"
export IS="ironswin@ironswine.com"
