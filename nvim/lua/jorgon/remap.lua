vim.g.mapleader = " "
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)
vim.keymap.set("n", ";", ":")

-- Window navigation with Alt+hjkl
vim.keymap.set("n", "<M-h>", "<C-w>h")
vim.keymap.set("n", "<M-l>", "<C-w>l")
vim.keymap.set("n", "<M-j>", "<C-w>j")
vim.keymap.set("n", "<M-k>", "<C-w>k")

-- Alt+Backspace to delete previous word in insert mode
vim.keymap.set("i", "<M-BS>", "<C-w>")
