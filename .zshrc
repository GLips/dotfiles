# Starship prompt will be initialized at the end of this file

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

plugins=(
  git
  zsh-syntax-highlighting
  zsh-autosuggestions
  last-working-dir
  vi-mode
  zsh-interactive-cd
  brew
  tmuxinator
  colored-man-pages
  extract
  history-substring-search
)

ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=7"
ZSH_AUTOSUGGEST_STRATEGY=(history completion)

# Skip OMZ's compinit, we handle it ourselves with caching
skip_global_compinit=1
source $ZSH/oh-my-zsh.sh

# Completions - regenerate cache once per day, otherwise use cache
autoload -Uz compinit
if [[ -f ~/.zcompdump && $(find ~/.zcompdump -mtime -1 2>/dev/null) ]]; then
  compinit -C
else
  compinit
fi

# ------------------------------
# zoxide (smarter cd) - must be after compinit
# ------------------------------
eval "$(zoxide init zsh)"

# ------------------------------
# Starship prompt
# ------------------------------
export STARSHIP_CONFIG=~/dotfiles/starship/starship.toml
eval "$(starship init zsh)"

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

# Enhanced fzf with previews
export FZF_DEFAULT_OPTS="--height 40% --layout=reverse --border --preview-window=right:60%"
export FZF_CTRL_T_OPTS="--preview 'bat --color=always --line-range :500 {}'"
export FZF_ALT_C_OPTS="--preview 'tree -C {} | head -200'"

# ------------------------------
# History Configuration
# ------------------------------
HISTSIZE=50000
SAVEHIST=50000
setopt EXTENDED_HISTORY          # Write timestamp to history
setopt INC_APPEND_HISTORY        # Add commands as they are typed
setopt SHARE_HISTORY             # Share history between sessions
setopt HIST_IGNORE_DUPS          # Ignore consecutive duplicates
setopt HIST_IGNORE_SPACE         # Ignore commands starting with space

# ------------------------------
# Completion Configuration
# ------------------------------
# Case-insensitive completion
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
# Menu selection for completion
zstyle ':completion:*' menu select

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
alias mux="tmuxinator"

# Neovim
alias oldvim="/usr/bin/vim"
alias vim="nvim"

# Claude

# ------------------------------
# Functions
# ------------------------------
# Quick backup of files
bak() { cp "$1" "$1.bak"; }


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
# Auto-refresh prompt, mostly for up to date git info
# ------------------------------
TMOUT=10  # refresh every 10 seconds

TRAPALRM() {
  # Only refresh if buffer is empty (not typing/in fzf/etc)
  if [[ -z "$BUFFER" ]]; then
    zle reset-prompt
  fi
}

# ------------------------------
# Misc
# ------------------------------
export SKIP_YARN_COREPACK_CHECK=1

# The next line updates PATH for the Google Cloud SDK.
if [ -f "$HOME/.google-cloud-sdk/path.zsh.inc" ]; then . "$HOME/.google-cloud-sdk/path.zsh.inc"; fi

# The next line enables shell command completion for gcloud.
if [ -f "$HOME/.google-cloud-sdk/completion.zsh.inc" ]; then . "$HOME/.google-cloud-sdk/completion.zsh.inc"; fi

# Added by Antigravity
export PATH="/Users/graham/.antigravity/antigravity/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"
