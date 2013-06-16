if [ "$UNAME" = Darwin ]; then
	# add color to ls
	alias ls='ls -G'
	# add color to grep
	alias grep='grep --color=auto'
	alias fgrep='fgrep --color=auto'
	alias egrep='egrep --color=auto'

	# Quicklook from terminal
	function ql ()
	{
		(qlmanage -p "$@" > /dev/null 2>&1 &
		local ql_pid=$!
		read -sn 1
		kill ${ql_pid}) > /dev/null 2>&1
	}

# Disable press-and-hold for keys in favor of key repeat
defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false

# Set a blazingly fast keyboard repeat rate
defaults write NSGlobalDomain KeyRepeat -int 0

# Disable opening and closing window animations
defaults write NSGlobalDomain NSAutomaticWindowAnimationsEnabled -bool false

# Enable full keyboard access for all controls (e.g. enable Tab in modal dialogs)
defaults write NSGlobalDomain AppleKeyboardUIMode -int 3

fi

