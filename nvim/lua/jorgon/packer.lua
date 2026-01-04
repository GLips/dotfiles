-- This file can be loaded by calling `lua require('plugins')` from your init.vim

-- Only required if you have packer configured as `opt`
vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
  -- Packer can manage itself
  use 'wbthomason/packer.nvim'

use {
        'nvim-telescope/telescope.nvim', tag = 'v0.2.1',
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
use 'nvim-treesitter/nvim-treesitter-context'

-- Treesitter text objects for functions, classes, parameters
use {
  'nvim-treesitter/nvim-treesitter-textobjects',
  after = 'nvim-treesitter'
}

-- File tree explorer
use {
  'nvim-neo-tree/neo-tree.nvim',
  branch = 'v3.x',
  requires = {
    'nvim-lua/plenary.nvim',
    'nvim-tree/nvim-web-devicons',
    'MunifTanjim/nui.nvim',
  }
}

-- LSP Support
use {
  'neovim/nvim-lspconfig',
  requires = {
    'williamboman/mason.nvim',
    'williamboman/mason-lspconfig.nvim',
  }
}

-- Autocompletion
use {
  'hrsh7th/nvim-cmp',
  requires = {
    'hrsh7th/cmp-nvim-lsp',
    'hrsh7th/cmp-buffer',
    'hrsh7th/cmp-path',
    'L3MON4D3/LuaSnip',
    'saadparwaiz1/cmp_luasnip',
  }
}

-- Git signs
use 'lewis6991/gitsigns.nvim'

-- Trouble - Pretty diagnostics list
use {
  'folke/trouble.nvim',
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
use 'folke/snacks.nvim'

-- Error Lens - Inline error messages
use 'chikko80/error-lens.nvim'

-- Colorscheme with excellent treesitter support
use 'folke/tokyonight.nvim'

-- Simple indentation guides
use "lukas-reineke/indent-blankline.nvim"

-- Rainbow delimiters for matching brackets
use 'HiPhish/rainbow-delimiters.nvim'

-- Detect tabstop and shiftwidth automatically
use 'tpope/vim-sleuth'

-- Smart commenting
use {
  'numToStr/Comment.nvim',
  config = function()
    require('Comment').setup()
  end
}

-- Auto pairs for brackets, quotes, etc.
use {
  'windwp/nvim-autopairs',
  config = function()
    require('nvim-autopairs').setup {}
  end
}

-- Collection of various small independent plugins/modules
use 'echasnovski/mini.nvim'

-- Highlight and search TODO comments
use {
  'folke/todo-comments.nvim',
  requires = 'nvim-lua/plenary.nvim'
}

-- Harpoon - Quick file navigation
use {
  'ThePrimeagen/harpoon',
  branch = 'harpoon2',
  requires = { 'nvim-lua/plenary.nvim', 'nvim-telescope/telescope.nvim' }
}

-- Note: Using enhanced native tabs instead of barbar

end)
