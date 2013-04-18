PATH=$PATH:$HOME/.rvm/bin # Add RVM to PATH for scripting
shopt -s expand_aliases
set -o vi

export CP="graham@dev.customerparadigm.com:/home/graham/public_html"
export CG="captiongenerator.com@captiongenerator.com"
export IS="ironswin@ironswine.com"

alias cgssh="ssh -i captiongenerator_rsa cg"
alias cpssh="ssh -ti ~/.ssh/cp_rsa graham@dev.customerparadigm.com \"cd /home/graham/public_html ; bash\""
alias isssh="ssh ironswin@ironswine.com"
alias ll="ls -laGF"
alias defend="bundle exec guard"
alias grep="grep --color=auto"
