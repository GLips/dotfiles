-- Setup Telescope with optimizations
require('telescope').setup {
  defaults = {
    -- Use ripgrep for faster searching
    vimgrep_arguments = {
      'rg',
      '--color=never',
      '--no-heading',
      '--with-filename',
      '--line-number',
      '--column',
      '--smart-case',
      '--hidden',  -- Search hidden files
    },
    -- Performance optimizations
    file_ignore_patterns = { "node_modules", ".git/", "dist/", "build/" },
    layout_config = {
      horizontal = {
        preview_width = 0.55,
      },
    },
    -- Keybindings
    mappings = {
      i = {
        -- Alt+Backspace to delete word
        ["<M-BS>"] = function() vim.api.nvim_input("<C-w>") end,
      },
    },
  },
  pickers = {
    find_files = {
      hidden = true,  -- Show hidden files
    },
  },
}

-- Load fzf native extension for faster sorting
pcall(require('telescope').load_extension, 'fzf')

-- Keybindings
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>pf', builtin.find_files, { desc = 'Telescope find files' })

-- Git files with untracked files included
vim.keymap.set('n', '<C-p>', function()
  builtin.git_files({ show_untracked = true })
end, { desc = 'Telescope git files (including untracked)' })

vim.keymap.set('n', '<leader>ps', function()
	builtin.grep_string({ search = vim.fn.input("Grep > ") });
end, { desc = 'Telescope grep' })
vim.keymap.set('n', '<leader>pg', builtin.live_grep, { desc = 'Telescope live grep' })

