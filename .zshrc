# Enable Powerlevel10k instant prompt. Should stay at the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# ------------------------------
# PATH configuration
# ------------------------------
export PATH=/opt/homebrew/bin:$PATH
export PATH="/Users/graham/Library/pnpm:$PATH"
export PATH="/Users/graham/.bun/bin:$PATH"

# ------------------------------
# Oh My Zsh configuration
# ------------------------------
export ZSH="/Users/graham/.oh-my-zsh"

zstyle ':omz:update' mode reminder
zstyle ':omz:update' frequency 13

plugins=(git zsh-syntax-highlighting zsh-autosuggestions last-working-dir vi-mode zsh-interactive-cd)

ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=7"

source $ZSH/oh-my-zsh.sh

# ------------------------------
# Powerlevel10k
# ------------------------------
source /opt/homebrew/share/powerlevel10k/powerlevel10k.zsh-theme
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# ------------------------------
# Editor
# ------------------------------
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR='nvim'
fi

# ------------------------------
# fzf
# ------------------------------
source /opt/homebrew/opt/fzf/shell/completion.zsh
source /opt/homebrew/opt/fzf/shell/key-bindings.zsh

# ------------------------------
# Aliases
# ------------------------------

# Make sure changing to normal mode is fast
KEYTIMEOUT=1

alias ll="ls -laFhG"
if [ "$(uname)" = Linux ]; then
  alias ll="ls -laFh --color=always"
fi
alias l="ll"
alias grep="grep --color=auto"
alias g="git"
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias c="clear"
alias s="ssh"

# Tmux
alias m="tmux"
alias ml="m ls"
alias ma="m att -t"

# Neovim
alias vim="nvim"

# Claude
alias claude="/Users/graham/.claude/local/claude"

# ------------------------------
# nvm (lazy loaded for faster startup)
# ------------------------------
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

nvm() {
  unfunction nvm
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
  nvm "$@"
}

node() {
  unfunction node
  unfunction nvm
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
  node "$@"
}

npm() {
  unfunction npm
  unfunction nvm
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
  npm "$@"
}

# ------------------------------
# pnpm
# ------------------------------
export PNPM_HOME="/Users/graham/Library/pnpm"

# ------------------------------
# bun
# ------------------------------
[ -s "/Users/graham/.bun/_bun" ] && source "/Users/graham/.bun/_bun"

# ------------------------------
# Misc
# ------------------------------
export SKIP_YARN_COREPACK_CHECK=1

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/graham/Downloads/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/graham/Downloads/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/graham/Downloads/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/graham/Downloads/google-cloud-sdk/completion.zsh.inc'; fi
