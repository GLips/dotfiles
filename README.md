# Dotfiles

Personal development environment configuration for macOS.

## Quick Start

To clone and set up dotfiles on a fresh machine:

```bash
curl https://raw.github.com/GLips/dotfiles/master/init.sh | bash
```

## Installation

The install script will:
- Install Homebrew (if not already installed)
- Install core tools and dependencies via Homebrew
- Set up Zsh with Oh My Zsh and plugins
- Create symlinks for configuration files
- Back up any existing dotfiles to `~/dotfiles_backup`

See `install.sh` for details on what gets installed.

## Structure

Dotfiles are stored in `~/dotfiles/` and symlinked to your home directory, making it easy to version control and sync across machines.
