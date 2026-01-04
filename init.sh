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
brew install fzf zoxide bat tree tmux neovim git

# Install fzf shell integrations
if [ -f $(brew --prefix)/opt/fzf/install ]; then
	echo "Installing fzf shell integrations..."
	$(brew --prefix)/opt/fzf/install --key-bindings --completion --no-update-rc
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
	ln -fs "$HOME/$dotfile_dir/nvim" "$HOME/.config/nvim"
	echo "✓ Neovim config linked to ~/.config/nvim"
fi

echo ""
echo "========================================="
echo "  Setup Complete!"
echo "========================================="
echo ""
echo "Next steps:"
echo "1. If this is your first time, run: p10k configure"
echo "2. Restart your terminal or run: source ~/.zshrc"
echo "3. Optional: Install nvm, pnpm, bun as needed"
echo ""
echo "Your old dotfiles have been backed up to ~/dotfiles_backup"
echo ""
