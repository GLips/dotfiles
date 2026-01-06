if vim.g.vscode then return end

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
        -- Enter opens file in new tab
        ["<CR>"] = "select_tab",
      },
      n = {
        -- Enter opens file in new tab
        ["<CR>"] = "select_tab",
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

-- Git files with fallback to find_files if not in a git repo
vim.keymap.set('n', '<C-p>', function()
  local ok = pcall(builtin.git_files, { show_untracked = true })
  if not ok then
    builtin.find_files()
  end
end, { desc = 'Telescope git files (fallback to find_files)' })

vim.keymap.set('n', '<leader>ps', function()
	builtin.grep_string({ search = vim.fn.input("Grep > ") });
end, { desc = 'Telescope grep' })
vim.keymap.set('n', '<leader>pg', builtin.live_grep, { desc = 'Telescope live grep' })

-- Ctrl+t opens Telescope file picker, selections open in new tab
vim.keymap.set('n', '<C-t>', builtin.find_files, { desc = 'Telescope find files (opens in new tab)' })

