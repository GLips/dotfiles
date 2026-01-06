-- OpenCode - AI coding assistant integration
local status_ok, opencode = pcall(require, 'opencode')
if not status_ok then
  return
end

---@type table
vim.g.opencode_opts = {
  provider = {
    enabled = false, -- Don't manage opencode - running it in terminal manually
  },
}

-- Required for auto-reload of edited buffers
vim.o.autoread = true

-- Keymaps
vim.keymap.set({ "n", "x" }, "<C-a>", function()
  opencode.ask("@this: ", { submit = true })
end, { desc = "Ask opencode" })

vim.keymap.set({ "n", "x" }, "<C-x>", function()
  opencode.select()
end, { desc = "Execute opencode action…" })

vim.keymap.set({ "n", "t" }, "<C-.>", function()
  opencode.toggle()
end, { desc = "Toggle opencode" })

-- Operator for adding ranges to opencode
vim.keymap.set({ "n", "x" }, "go", function()
  return opencode.operator("@this ")
end, { expr = true, desc = "Add range to opencode" })

vim.keymap.set("n", "goo", function()
  return opencode.operator("@this ") .. "_"
end, { expr = true, desc = "Add line to opencode" })

-- Scroll commands for opencode session
vim.keymap.set("n", "<S-C-u>", function()
  opencode.command("session.half.page.up")
end, { desc = "opencode half page up" })

vim.keymap.set("n", "<S-C-d>", function()
  opencode.command("session.half.page.down")
end, { desc = "opencode half page down" })

-- Remap increment/decrement since we're using <C-a> and <C-x>
vim.keymap.set("n", "+", "<C-a>", { desc = "Increment", noremap = true })
vim.keymap.set("n", "-", "<C-x>", { desc = "Decrement", noremap = true })
