if vim.g.vscode then return end

-- Snacks - Collection of useful utilities
local status_ok, snacks = pcall(require, 'snacks')
if not status_ok then
  return
end

snacks.setup {
  rename = { enabled = true },
  input = { enabled = true },   -- Required for opencode.nvim ask()
  picker = { enabled = true },  -- Required for opencode.nvim select()
  terminal = { enabled = true }, -- Optional but useful for opencode
}
