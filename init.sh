#!/bin/bash
# Install script for dotfile customizations
# Modified from https://github.com/alexdavid/dotfiles

# Exit on error
set -e

echo "========================================="
echo "  Dotfiles Setup Script"
echo "========================================="

# Install Homebrew if not present
if ! command -v brew &> /dev/null; then
	echo "Installing Homebrew..."
	/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

	# Add Homebrew to PATH for Apple Silicon Macs
	if [[ $(uname -m) == 'arm64' ]]; then
		echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
		eval "$(/opt/homebrew/bin/brew shellenv)"
	fi
else
	echo "✓ Homebrew already installed"
fi

# Install essential packages via Homebrew
echo "Installing/updating packages via Homebrew..."
brew install fzf zoxide bat tree tmux neovim git opencode tmuxinator biome prettier

# Install fzf shell integrations
if [ -f $(brew --prefix)/opt/fzf/install ]; then
	echo "Installing fzf shell integrations..."
	$(brew --prefix)/opt/fzf/install --key-bindings --completion --no-update-rc
fi

# Install nvm (Node Version Manager)
if [ ! -d "$HOME/.nvm" ]; then
	echo "Installing nvm..."
	curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash
	# Load nvm for this script
	export NVM_DIR="$HOME/.nvm"
	[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
	echo "✓ nvm installed"
else
	echo "✓ nvm already installed"
fi

# Install bun
if ! command -v bun &> /dev/null; then
	echo "Installing bun..."
	curl -fsSL https://bun.sh/install | bash
	echo "✓ bun installed"
else
	echo "✓ bun already installed"
fi

# Install Oh My Zsh if not present
if [ ! -d "$HOME/.oh-my-zsh" ]; then
	echo "Installing Oh My Zsh..."
	sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
else
	echo "✓ Oh My Zsh already installed"
fi

# Install zsh plugins
ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

if [ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]; then
	echo "Installing zsh-syntax-highlighting..."
	git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
else
	echo "✓ zsh-syntax-highlighting already installed"
fi

if [ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]; then
	echo "Installing zsh-autosuggestions..."
	git clone https://github.com/zsh-users/zsh-autosuggestions.git "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
else
	echo "✓ zsh-autosuggestions already installed"
fi

# Install Powerlevel10k theme
if [ ! -d "$ZSH_CUSTOM/themes/powerlevel10k" ]; then
	echo "Installing Powerlevel10k theme..."
	brew install powerlevel10k
else
	echo "✓ Powerlevel10k already installed"
fi

echo ""
echo "========================================="
echo "  Setting up dotfiles"
echo "========================================="

cd

# Backup existing files
backup_dir="dotfiles_backup"
if [ -e $backup_dir ]
then
	rm -rf $backup_dir
fi
mkdir $backup_dir

dotfile_dir="dotfiles"
if [  -e $dotfile_dir ]
then
	rm -rf $dotfile_dir
fi
mkdir $dotfile_dir

echo -e "Looking for files that would be overwritten."
for i in \
	".bash"\
	".bashrc"\
	".git"\
	".gitconfig"\
	".vimrc"\
	".vim"\
	".tmux.conf"\
	".vim_settings"
do
	if [ -e "$i" ]
	then
		echo -e "Moving $i to $backup_dir/$i"
		mv $i "$backup_dir/$i"
	fi
done

# Backup nvim config if it exists
if [ -e "$HOME/.config/nvim" ]; then
	echo -e "Moving .config/nvim to $backup_dir/nvim"
	mkdir -p "$backup_dir"
	mv "$HOME/.config/nvim" "$backup_dir/nvim"
fi

# Move into the dotfiles directory to keep it compartmentalized
cd $dotfile_dir

# Pull down repo
if [[ $(git config --get remote.origin.url) != "git://github.com/GLips/dotfiles.git" ]]
then
	git init
	git remote add origin git@github.com:GLips/dotfiles.git
	git fetch
	git branch master origin/master
	git checkout master
else
	git fetch
fi
touch .gitignore
echo "README.md" >> .gitignore
echo "init.sh" >> .gitignore

cd ..

for f in $dotfile_dir/.*
do
	b=$(basename $f)
	if [ $b != ".git" ] && [ $b != ".gitignore" ] && [ $b != ".." ] && [ $b != "." ]
	then
		ln -fs $f $b
	fi
done

# Set up Neovim config
if [ -d "$dotfile_dir/nvim" ]; then
	echo "Setting up Neovim configuration..."
	mkdir -p "$HOME/.config"
	# Remove existing nvim config if it exists (already backed up earlier)
	rm -rf "$HOME/.config/nvim"
	ln -s "$HOME/$dotfile_dir/nvim" "$HOME/.config/nvim"
	echo "✓ Neovim config linked to ~/.config/nvim"
fi

# Set up Ghostty config
if [ -f "$dotfile_dir/ghostty/config" ]; then
	echo "Setting up Ghostty configuration..."
	ghostty_config_dir="$HOME/Library/Application Support/com.mitchellh.ghostty"
	mkdir -p "$ghostty_config_dir"
	# Backup existing config if present
	if [ -f "$ghostty_config_dir/config" ] && [ ! -L "$ghostty_config_dir/config" ]; then
		mv "$ghostty_config_dir/config" "$backup_dir/ghostty_config"
	fi
	ln -sf "$HOME/$dotfile_dir/ghostty/config" "$ghostty_config_dir/config"
	echo "✓ Ghostty config linked"
fi

# Set up OpenCode config
if [ -f "$dotfile_dir/opencode/opencode.jsonc" ]; then
	echo "Setting up OpenCode configuration..."
	opencode_config_dir="$HOME/.config/opencode"
	opencode_config_file="$opencode_config_dir/opencode.jsonc"
	
	if [ -f "$opencode_config_file" ] && [ ! -L "$opencode_config_file" ]; then
		echo ""
		echo "========================================="
		echo "⚠️  WARNING: EXISTING OPENCODE CONFIG FOUND!"
		echo "========================================="
		echo "An OpenCode configuration already exists at:"
		echo "  $opencode_config_file"
		echo ""
		echo "This script will NOT overwrite it automatically."
		echo "Please manually review and merge configurations:"
		echo "  Source: $HOME/$dotfile_dir/opencode/opencode.jsonc"
		echo "  Target: $opencode_config_file"
		echo "========================================="
		echo ""
	else
		mkdir -p "$opencode_config_dir"
		# Remove existing symlink if present
		rm -f "$opencode_config_file"
		ln -sf "$HOME/$dotfile_dir/opencode/opencode.jsonc" "$opencode_config_file"
		echo "✓ OpenCode config linked to ~/.config/opencode/opencode.jsonc"
	fi
fi

# Set up tmuxinator config
if [ -d "$dotfile_dir/tmuxinator" ]; then
	echo "Setting up tmuxinator configuration..."
	tmuxinator_config_dir="$HOME/.config/tmuxinator"
	mkdir -p "$tmuxinator_config_dir"
	# Backup existing tmuxinator configs if present
	if [ -d "$tmuxinator_config_dir" ] && [ ! -L "$tmuxinator_config_dir" ]; then
		for config_file in "$tmuxinator_config_dir"/*.yml; do
			if [ -f "$config_file" ]; then
				config_basename=$(basename "$config_file")
				# Only backup if not already a symlink
				if [ ! -L "$config_file" ]; then
					mv "$config_file" "$backup_dir/tmuxinator_$config_basename"
					echo "Backed up $config_basename"
				fi
			fi
		done
	fi
	# Symlink all yml files from dotfiles/tmuxinator to ~/.config/tmuxinator
	for config_file in "$HOME/$dotfile_dir/tmuxinator"/*.yml; do
		if [ -f "$config_file" ]; then
			config_basename=$(basename "$config_file")
			ln -sf "$config_file" "$tmuxinator_config_dir/$config_basename"
			echo "✓ Linked $config_basename"
		fi
	done
	echo "✓ Tmuxinator configs linked to ~/.config/tmuxinator/"
fi

# Install Tmux Plugin Manager (TPM)
if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
	echo "Installing Tmux Plugin Manager (TPM)..."
	git clone https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"
	echo "✓ TPM installed"
else
	echo "✓ TPM already installed"
fi

echo ""
echo "========================================="
echo "  Setup Complete!"
echo "========================================="
echo ""
echo "Next steps:"
echo "1. If this is your first time, run: p10k configure"
echo "2. Restart your terminal or run: source ~/.zshrc"
echo "3. Install tmux plugins: Open tmux and press Ctrl-a + Shift-I"
echo "4. Optional: Install a Node.js version with nvm (e.g., nvm install --lts)"
echo "5. Optional: Install pnpm if needed"
echo ""
echo "Your old dotfiles have been backed up to ~/dotfiles_backup"
echo ""
