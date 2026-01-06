if vim.g.vscode then return end

local status_ok, trouble = pcall(require, 'trouble')
if not status_ok then
  return
end

trouble.setup {
  -- New Trouble v3 configuration
  auto_close = false,
  auto_open = false,
  auto_preview = true,
  auto_refresh = true,
  focus = false,
  modes = {
    diagnostics = {
      mode = "diagnostics",
    },
  },
}

-- Keybindings (only set if trouble loaded successfully)
if status_ok then
  vim.keymap.set("n", "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", { desc = "Diagnostics (Trouble)" })
  vim.keymap.set("n", "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", { desc = "Buffer Diagnostics (Trouble)" })
  vim.keymap.set("n", "<leader>cs", "<cmd>Trouble symbols toggle focus=false<cr>", { desc = "Symbols (Trouble)" })
  vim.keymap.set("n", "<leader>cl", "<cmd>Trouble lsp toggle focus=false win.position=right<cr>", { desc = "LSP Definitions / references / ... (Trouble)" })
  vim.keymap.set("n", "<leader>xL", "<cmd>Trouble loclist toggle<cr>", { desc = "Location List (Trouble)" })
  vim.keymap.set("n", "<leader>xQ", "<cmd>Trouble qflist toggle<cr>", { desc = "Quickfix List (Trouble)" })
  vim.keymap.set("n", "gR", "<cmd>Trouble lsp_references toggle<cr>", { desc = "LSP References (Trouble)" })
end
