alias ll="ls -laFh"
if [ "$(uname)" = Linux ]; then
	alias ll="ls -laFh --color=always"
fi
alias l="ll"
alias defend="bundle exec guard"
alias grep="grep --color=auto"
alias g="git"
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias c="clear"
alias s="ssh"

# Tmux bindings
alias m="tmux"
alias ml="m ls"
alias ma="m att -t"
