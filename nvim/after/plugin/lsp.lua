if vim.g.vscode then return end

-- Setup Mason (LSP installer)
require("mason").setup()
require("mason-lspconfig").setup({
  ensure_installed = {
    "ts_ls",     -- TypeScript/JavaScript
    "lua_ls",    -- Lua
    "biome",     -- Fast linter/formatter for JS/TS
    "eslint",    -- ESLint language server
  },
  automatic_installation = true,
})

-- LSP keybindings (only active when LSP is attached)
local on_attach = function(event)
  -- Helper function to make keybinding setup easier
  local map = function(keys, func, desc)
    vim.keymap.set('n', keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
  end

  -- Jump to the definition of the word under your cursor (with Telescope)
  --  To jump back, press <C-t>
  map('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')

  -- Find references for the word under your cursor (with Telescope)
  map('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')

  -- Jump to the implementation of the word under your cursor (with Telescope)
  --  Useful when your language has ways of declaring types without an actual implementation
  map('gI', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')

  -- Jump to the type of the word under your cursor (with Telescope)
  --  Useful when you're not sure what type a variable is
  map('<leader>D', require('telescope.builtin').lsp_type_definitions, 'Type [D]efinition')

  -- Fuzzy find all the symbols in your current document (with Telescope)
  --  Symbols are things like variables, functions, types, etc.
  map('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')

  -- Fuzzy find all the symbols in your current workspace (with Telescope)
  --  Similar to document symbols, except searches over your entire project
  map('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')

  -- Rename the variable under your cursor (using lspsaga for better UI)
  --  Most Language Servers support renaming across files
  map('<leader>rn', '<cmd>Lspsaga rename<CR>', '[R]e[n]ame')

  -- Execute a code action (using lspsaga for better UI)
  map('<leader>ca', '<cmd>Lspsaga code_action<CR>', '[C]ode [A]ction')
  map('<C-.>', '<cmd>Lspsaga code_action<CR>', '[C]ode [A]ction')  -- Alternative binding (like VSCode)

  -- Opens a popup that displays documentation (using lspsaga for better rendering)
  map('K', '<cmd>Lspsaga hover_doc<CR>', 'Hover Documentation')

  -- Lspsaga finder - shows references, definitions, implementations all in one
  map('gh', '<cmd>Lspsaga finder<CR>', 'LSP Finder')

  -- Peek definition (without jumping)
  map('gp', '<cmd>Lspsaga peek_definition<CR>', '[P]eek definition')

  -- Peek type definition
  map('gt', '<cmd>Lspsaga peek_type_definition<CR>', 'Peek [T]ype definition')

  -- Goto Declaration (not definition - for example, in C this takes you to the header)
  map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

  -- Open diagnostics in a float
  map('<leader>vd', vim.diagnostic.open_float, '[V]iew [D]iagnostics')

  vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Show diagnostic [E]rror messages' })
  vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

  -- Navigate diagnostics
  vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { buffer = event.buf, desc = 'Previous diagnostic' })
  vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { buffer = event.buf, desc = 'Next diagnostic' })

  -- Signature help in insert mode
  vim.keymap.set('i', '<C-h>', vim.lsp.buf.signature_help, { buffer = event.buf, desc = 'Signature help' })

  -- Document highlighting: highlight references of the word under your cursor
  local client = vim.lsp.get_client_by_id(event.data.client_id)
  if client and client.server_capabilities.documentHighlightProvider then
    local highlight_augroup = vim.api.nvim_create_augroup('lsp-highlight', { clear = false })
    vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
      buffer = event.buf,
      group = highlight_augroup,
      callback = vim.lsp.buf.document_highlight,
    })

    vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
      buffer = event.buf,
      group = highlight_augroup,
      callback = vim.lsp.buf.clear_references,
    })

    vim.api.nvim_create_autocmd('LspDetach', {
      group = vim.api.nvim_create_augroup('lsp-detach', { clear = true }),
      callback = function(event2)
        vim.lsp.buf.clear_references()
        vim.api.nvim_clear_autocmds { group = 'lsp-highlight', buffer = event2.buf }
      end,
    })
  end

  -- Inlay hints toggle (if supported by language server)
  if client and client.server_capabilities.inlayHintProvider and vim.lsp.inlay_hint then
    map('<leader>ti', function()
      vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
    end, '[T]oggle [I]nlay hints')
  end
end

-- Setup LSP capabilities for autocomplete
local capabilities = require('cmp_nvim_lsp').default_capabilities()

-- Configure TypeScript/JavaScript LSP using new vim.lsp.config API
vim.lsp.config('ts_ls', {
  cmd = { 'typescript-language-server', '--stdio' },
  filetypes = { 'javascript', 'javascriptreact', 'typescript', 'typescriptreact' },
  root_markers = { 'package.json', 'tsconfig.json', 'jsconfig.json' },
  capabilities = capabilities,
})

vim.lsp.enable('ts_ls')

-- Configure Lua LSP using new vim.lsp.config API
vim.lsp.config('lua_ls', {
  cmd = { 'lua-language-server' },
  filetypes = { 'lua' },
  root_markers = { '.luarc.json', '.luarc.jsonc', '.luacheckrc', '.stylua.toml', 'stylua.toml', 'selene.toml', 'selene.yml' },
  settings = {
    Lua = {
      diagnostics = {
        globals = { 'vim' }  -- Recognize 'vim' global in Neovim config
      }
    }
  },
  capabilities = capabilities,
})

vim.lsp.enable('lua_ls')

-- Configure Biome LSP (fast linter/formatter for JS/TS/JSON)
vim.lsp.config('biome', {
  cmd = { 'biome', 'lsp-proxy' },
  filetypes = {
    'javascript',
    'javascriptreact',
    'typescript',
    'typescriptreact',
    'json',
    'jsonc',
  },
  root_markers = { 'biome.json', 'biome.jsonc' },
  single_file_support = true,
  capabilities = capabilities,
})

vim.lsp.enable('biome')

-- Configure ESLint LSP
vim.lsp.config('eslint', {
  cmd = { 'vscode-eslint-language-server', '--stdio' },
  filetypes = {
    'javascript',
    'javascriptreact',
    'typescript',
    'typescriptreact',
  },
  root_markers = {
    '.eslintrc',
    '.eslintrc.js',
    '.eslintrc.cjs',
    '.eslintrc.yaml',
    '.eslintrc.yml',
    '.eslintrc.json',
    'eslint.config.js',
    'package.json',
  },
  settings = {
    format = false,  -- Let biome or prettier handle formatting
    codeAction = {
      disableRuleComment = {
        enable = true,
        location = "separateLine"
      },
      showDocumentation = {
        enable = true,
      }
    },
    codeActionOnSave = {
      enable = false,
      mode = "all"
    },
    experimental = {},
    problems = {
      shortenToSingleLine = false,
    },
    workingDirectory = {
      mode = "auto",
    }
  },
  capabilities = capabilities,
})

vim.lsp.enable('eslint')

-- Setup on_attach for all LSPs
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('lsp-attach', { clear = true }),
  callback = function(event)
    on_attach(event)
  end,
})
