-- This file can be loaded by calling `lua require('plugins')` from your init.vim

-- Only required if you have packer configured as `opt`
vim.cmd [[packadd packer.nvim]]

-- Helper for plugins that should only load in regular Neovim (not VSCode)
local not_vscode = not vim.g.vscode

return require('packer').startup(function(use)
  -- Packer can manage itself
  use 'wbthomason/packer.nvim'

use {
        'nvim-telescope/telescope.nvim', tag = 'v0.2.1',
        cond = not_vscode,
        requires = {
      	  'nvim-lua/plenary.nvim',
      	  { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
        }
}

-- Use master branch for stable API
use {
  'nvim-treesitter/nvim-treesitter',
  branch = 'master',
  run = ':TSUpdate'
}

-- Show code context (function/class you're in) at top of screen
use {
  'nvim-treesitter/nvim-treesitter-context',
  cond = not_vscode,
}

-- Treesitter text objects for functions, classes, parameters
use {
  'nvim-treesitter/nvim-treesitter-textobjects',
  after = 'nvim-treesitter'
}

-- File tree explorer
use {
  'nvim-neo-tree/neo-tree.nvim',
  branch = 'v3.x',
  cond = not_vscode,
  requires = {
    'nvim-lua/plenary.nvim',
    'nvim-tree/nvim-web-devicons',
    'MunifTanjim/nui.nvim',
  }
}

-- LSP Support
use {
  'neovim/nvim-lspconfig',
  cond = not_vscode,
  requires = {
    'williamboman/mason.nvim',
    'williamboman/mason-lspconfig.nvim',
  }
}

-- TypeScript-specific tools and actions
use {
  'pmizio/typescript-tools.nvim',
  cond = not_vscode,
  requires = { 'nvim-lua/plenary.nvim', 'neovim/nvim-lspconfig' },
}

-- LSP UI improvements (code actions, hover, rename, finder, etc.)
use {
  'nvimdev/lspsaga.nvim',
  cond = not_vscode,
  after = 'nvim-lspconfig',
  requires = {
    'nvim-treesitter/nvim-treesitter',
    'nvim-tree/nvim-web-devicons',
  },
}

-- Autocompletion
use {
  'hrsh7th/nvim-cmp',
  cond = not_vscode,
  requires = {
    'hrsh7th/cmp-nvim-lsp',
    'hrsh7th/cmp-buffer',
    'hrsh7th/cmp-path',
    'L3MON4D3/LuaSnip',
    'saadparwaiz1/cmp_luasnip',
  }
}

-- Git signs
use {
  'lewis6991/gitsigns.nvim',
  cond = not_vscode,
}

-- Git diff view with file panel
use {
  'sindrets/diffview.nvim',
  cond = not_vscode,
  requires = 'nvim-lua/plenary.nvim'
}

-- Trouble - Pretty diagnostics list
use {
  'folke/trouble.nvim',
  cond = not_vscode,
  requires = 'nvim-tree/nvim-web-devicons',
}

-- Which Key - Show keybindings in popup
use {
  'folke/which-key.nvim',
  config = function()
    require('which-key').setup {}
  end
}

-- Snacks - Collection of useful utilities
use {
  'folke/snacks.nvim',
  cond = not_vscode,
}

-- Error Lens - Inline error messages
use {
  'chikko80/error-lens.nvim',
  cond = not_vscode,
}

-- Colorscheme with excellent treesitter support
use {
  'folke/tokyonight.nvim',
  cond = not_vscode,
}

-- Simple indentation guides
use {
  "lukas-reineke/indent-blankline.nvim",
  cond = not_vscode,
}

-- Rainbow delimiters for matching brackets
use {
  'HiPhish/rainbow-delimiters.nvim',
  cond = not_vscode,
}

-- Detect tabstop and shiftwidth automatically
use 'tpope/vim-sleuth'

-- Auto pairs for brackets, quotes, etc.
use {
  'windwp/nvim-autopairs',
  cond = not_vscode,
  config = function()
    require('nvim-autopairs').setup {}
  end
}

-- Collection of various small independent plugins/modules
use 'echasnovski/mini.nvim'

-- Lualine - Better statusline with plugin support
use {
  'nvim-lualine/lualine.nvim',
  cond = not_vscode,
  requires = { 'nvim-tree/nvim-web-devicons' }
}

-- Highlight and search TODO comments
use {
  'folke/todo-comments.nvim',
  cond = not_vscode,
  requires = 'nvim-lua/plenary.nvim'
}

-- Harpoon - Quick file navigation
use {
  'ThePrimeagen/harpoon',
  cond = not_vscode,
  branch = 'harpoon2',
  requires = { 'nvim-lua/plenary.nvim', 'nvim-telescope/telescope.nvim' }
}

-- Tmux Navigator - Seamless navigation between tmux and vim panes
use {
  'christoomey/vim-tmux-navigator',
  cond = not_vscode,
}

-- Auto session management
use {
  'rmagatti/auto-session',
  cond = not_vscode,
}

-- Formatting plugin with support for multiple formatters
use {
  'stevearc/conform.nvim',
  cond = not_vscode,
}

-- Flash - Fast and modern motion plugin
use {
  'folke/flash.nvim',
  -- Config is in after/plugin/flash.lua
}

-- Obsidian - Obsidian vault integration
use {
  'epwalsh/obsidian.nvim',
  cond = not_vscode,
  tag = '*',
  requires = {
    'nvim-lua/plenary.nvim',
  },
}

-- OpenCode - AI coding assistant integration
use {
  'NickvanDyke/opencode.nvim',
  cond = not_vscode,
  requires = {
    'folke/snacks.nvim',
  },
}

-- Surround - Add/delete/replace surroundings (brackets, quotes, etc.)
use {
  'kylechui/nvim-surround',
  tag = '*',
  config = function()
    require('nvim-surround').setup({})
  end
}

-- Note: Using enhanced native tabs instead of barbar

end)
