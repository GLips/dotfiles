-- Default yank to clipboard
vim.opt.clipboard:append("unnamedplus")

vim.keymap.set("n", "<C-h>", function() vim.cmd.tabprevious() end)
vim.keymap.set("n", "<C-l>", function() vim.cmd.tabnext() end)

vim.opt.termguicolors = false
require("jorgon")
