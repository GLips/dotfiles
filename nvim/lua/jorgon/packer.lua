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

use('nvim-treesitter/nvim-treesitter', {run = ':TSUpdate'})

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

end)
