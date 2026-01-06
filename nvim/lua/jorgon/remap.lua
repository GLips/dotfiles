-- Leader is set in init.lua
-- vim.keymap.set("n", ";", ":")

-- jj to escape in insert mode
vim.keymap.set("i", "jj", "<Esc>", { desc = "Exit insert mode" })

-- Yank to system clipboard (only y, not d or c)
vim.keymap.set({"n", "v"}, "y", '"+y', { desc = "Yank to system clipboard" })
vim.keymap.set("n", "Y", '"+y$', { desc = "Yank to end of line (system clipboard)" })
vim.keymap.set("n", "yy", '"+yy', { desc = "Yank whole line (system clipboard)" })

-- Test that leader works
vim.keymap.set("n", "<leader>w", ":w<CR>", { desc = "Save file" })

-- Toggle line numbers
vim.keymap.set("n", "<C-S-n>", ":set number!<CR>", { desc = "Toggle line numbers", silent = true })

-- Window splits (matching tmux bindings)
vim.keymap.set("n", "<leader>|", ":vsplit<CR>", { desc = "Vertical split" })
vim.keymap.set("n", "<leader>=", ":split<CR>", { desc = "Horizontal split" })

-- Window navigation with Alt+hjkl (works with tmux-navigator)
-- Only in regular Neovim, not VSCode
if not vim.g.vscode then
  -- Disable default vim-tmux-navigator keybindings
  vim.g.tmux_navigator_no_mappings = 1

  vim.keymap.set("n", "<M-h>", ":TmuxNavigateLeft<CR>", { silent = true })
  vim.keymap.set("n", "<M-l>", ":TmuxNavigateRight<CR>", { silent = true })
  vim.keymap.set("n", "<M-j>", ":TmuxNavigateDown<CR>", { silent = true })
  vim.keymap.set("n", "<M-k>", ":TmuxNavigateUp<CR>", { silent = true })
end

-- Alt+Backspace to delete previous word in insert mode
vim.keymap.set("i", "<M-BS>", "<C-w>")

-- Unmap space in visual mode (leader key, not useful for moving forward)
vim.keymap.set("x", "<Space>", "<Nop>", { desc = "Disabled (use as leader)" })

-- Visual mode: exit and place cursor at start/end of selection
-- Mnemonic: <leader>i like I (insert at beginning), <leader>a like A (append at end)
vim.keymap.set("x", "<leader>i", "<Esc>`<", { desc = "Exit visual, cursor at start" })
vim.keymap.set("x", "<leader>a", "<Esc>`>", { desc = "Exit visual, cursor at end" })
