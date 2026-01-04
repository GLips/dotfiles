-- Leader is set in init.lua
vim.keymap.set("n", ";", ":")

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

-- Window navigation with Alt+hjkl
vim.keymap.set("n", "<M-h>", "<C-w>h")
vim.keymap.set("n", "<M-l>", "<C-w>l")
vim.keymap.set("n", "<M-j>", "<C-w>j")
vim.keymap.set("n", "<M-k>", "<C-w>k")

-- Alt+Backspace to delete previous word in insert mode
vim.keymap.set("i", "<M-BS>", "<C-w>")
