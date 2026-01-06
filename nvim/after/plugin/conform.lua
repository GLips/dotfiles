if vim.g.vscode then return end

require("conform").setup({
  -- Define formatters by filetype
  formatters_by_ft = {
    javascript = { "biome", "prettier" },
    javascriptreact = { "biome", "prettier" },
    typescript = { "biome", "prettier" },
    typescriptreact = { "biome", "prettier" },
    json = { "biome", "prettier" },
    jsonc = { "biome", "prettier" },
    css = { "prettier" },
    scss = { "prettier" },
    html = { "prettier" },
    markdown = { "prettier" },
    yaml = { "prettier" },
    lua = { "stylua" },
  },

  -- Format after save (async, non-blocking)
  format_after_save = function(bufnr)
    -- Disable with a global or buffer-local variable
    if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
      return
    end
    return { lsp_fallback = true }
  end,

  -- Customize formatter options
  formatters = {
    biome = {
      -- Biome will be preferred if biome.json exists in project
      condition = function(ctx)
        return vim.fs.find({ "biome.json", "biome.jsonc" }, { path = ctx.filename, upward = true })[1]
      end,
    },
    prettier = {
      -- Only use prettier if biome config doesn't exist
      condition = function(ctx)
        return not vim.fs.find({ "biome.json", "biome.jsonc" }, { path = ctx.filename, upward = true })[1]
      end,
      -- Use project-local prettier from node_modules
      require_cwd = true,
    },
  },
})

-- Keymap to manually format
vim.keymap.set({ "n", "v" }, "<leader>f", function()
  require("conform").format({ async = true, lsp_fallback = true })
end, { desc = "Format buffer" })

-- Command to toggle format on save
vim.api.nvim_create_user_command("FormatToggle", function()
  vim.g.disable_autoformat = not vim.g.disable_autoformat
  if vim.g.disable_autoformat then
    print("Format on save disabled")
  else
    print("Format on save enabled")
  end
end, { desc = "Toggle format on save" })
