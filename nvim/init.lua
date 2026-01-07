-- Set leader key FIRST before anything else
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Line numbers
vim.opt.number = true
vim.opt.relativenumber = false

-- Tab navigation (only in regular Neovim, VSCode handles tabs)
if not vim.g.vscode then
  vim.keymap.set("n", "<C-h>", function() vim.cmd.tabprevious() end)
  vim.keymap.set("n", "<C-l>", function() vim.cmd.tabnext() end)
  vim.opt.termguicolors = true
end
require("jorgon")

-- Make wrapped lines indent to actual text
vim.opt.breakindent = true

-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Keep signcolumn on by default
vim.opt.signcolumn = 'yes'

-- Configure how new splits should be opened
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Sets how neovim will display certain whitespace characters in the editor.
vim.opt.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

-- Preview substitutions live
vim.opt.inccommand = 'split'

-- Show which line your cursor is on
vim.opt.cursorline = true

-- Set highlight on search, but clear on pressing <Esc> in normal mode
vim.opt.hlsearch = true
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- TreeSitter-based folding (only in regular Neovim, VSCode handles folding)
if not vim.g.vscode then
  vim.opt.foldmethod = "expr"
  vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
  vim.opt.foldenable = true
  vim.opt.foldlevel = 99  -- Start with all folds open

  -- Only save buffers and tabs in sessions, not settings
  -- This prevents stale config settings from being restored
  vim.opt.sessionoptions = "buffers,tabpages"
end

vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- VSCode-specific configuration
if vim.g.vscode then
  local vscode = require('vscode')

  -- Use VSCode's save command (avoids any Neovim formatting)
  vim.keymap.set('n', '<leader>w', function()
    vscode.action('workbench.action.files.save')
  end, { desc = 'Save file (VSCode)' })

  -- Format document using VSCode's formatter
  vim.keymap.set({ 'n', 'v' }, '<leader>f', function()
    vscode.action('editor.action.formatDocument')
  end, { desc = 'Format document (VSCode)' })

  -- Code actions (like quick fixes)
  vim.keymap.set('n', '<leader>ca', function()
    vscode.action('editor.action.quickFix')
  end, { desc = 'Code actions (VSCode)' })

  vim.keymap.set('n', '<C-.>', function()
    vscode.action('editor.action.quickFix')
  end, { desc = 'Quick fix (VSCode)' })

  -- Go to definition
  vim.keymap.set('n', 'gd', function()
    vscode.action('editor.action.revealDefinition')
  end, { desc = 'Go to definition (VSCode)' })

  -- Go to references
  vim.keymap.set('n', 'gr', function()
    vscode.action('editor.action.goToReferences')
  end, { desc = 'Go to references (VSCode)' })

  -- Hover documentation
  vim.keymap.set('n', 'K', function()
    vscode.action('editor.action.showHover')
  end, { desc = 'Show hover (VSCode)' })

  -- Rename symbol
  vim.keymap.set('n', '<leader>rn', function()
    vscode.action('editor.action.rename')
  end, { desc = 'Rename symbol (VSCode)' })

  -- Find in files
  vim.keymap.set('n', '<leader>/', function()
    vscode.action('workbench.action.findInFiles')
  end, { desc = 'Find in files (VSCode)' })

  -- File explorer
  vim.keymap.set('n', '<leader>e', function()
    vscode.action('workbench.view.explorer')
  end, { desc = 'Open explorer (VSCode)' })

  -- Toggle sidebar
  vim.keymap.set('n', '<leader>b', function()
    vscode.action('workbench.action.toggleSidebarVisibility')
  end, { desc = 'Toggle sidebar (VSCode)' })

  -- Go to file (quick open)
  vim.keymap.set('n', '<C-p>', function()
    vscode.action('workbench.action.quickOpen')
  end, { desc = 'Quick open file (VSCode)' })

  -- Command palette
  vim.keymap.set('n', '<leader>p', function()
    vscode.action('workbench.action.showCommands')
  end, { desc = 'Command palette (VSCode)' })

  -- Navigate between editor groups (splits)
  vim.keymap.set('n', '<C-h>', function()
    vscode.action('workbench.action.focusLeftGroup')
  end, { desc = 'Focus left group (VSCode)' })

  vim.keymap.set('n', '<C-l>', function()
    vscode.action('workbench.action.focusRightGroup')
  end, { desc = 'Focus right group (VSCode)' })

  vim.keymap.set('n', '<C-j>', function()
    vscode.action('workbench.action.focusBelowGroup')
  end, { desc = 'Focus below group (VSCode)' })

  vim.keymap.set('n', '<C-k>', function()
    vscode.action('workbench.action.focusAboveGroup')
  end, { desc = 'Focus above group (VSCode)' })

  -- Bracket navigation (matches treesitter textobjects and gitsigns)
  -- Git hunks
  vim.keymap.set('n', ']c', function()
    vscode.action('workbench.action.editor.nextChange')
  end, { desc = 'Next git change (VSCode)' })

  vim.keymap.set('n', '[c', function()
    vscode.action('workbench.action.editor.previousChange')
  end, { desc = 'Previous git change (VSCode)' })

  -- Diagnostics
  vim.keymap.set('n', ']d', function()
    vscode.action('editor.action.marker.next')
  end, { desc = 'Next diagnostic (VSCode)' })

  vim.keymap.set('n', '[d', function()
    vscode.action('editor.action.marker.prev')
  end, { desc = 'Previous diagnostic (VSCode)' })

  -- Symbol occurrences (different from treesitter, but useful)
  vim.keymap.set('n', ']r', function()
    vscode.action('editor.action.wordHighlight.next')
  end, { desc = 'Next reference (VSCode)' })

  vim.keymap.set('n', '[r', function()
    vscode.action('editor.action.wordHighlight.prev')
  end, { desc = 'Previous reference (VSCode)' })

  -- Folding regions (somewhat similar to function navigation)
  vim.keymap.set('n', ']z', function()
    vscode.action('editor.gotoNextFold')
  end, { desc = 'Next fold (VSCode)' })

  vim.keymap.set('n', '[z', function()
    vscode.action('editor.gotoPreviousFold')
  end, { desc = 'Previous fold (VSCode)' })

  -- Git hunk actions (leader h, like gitsigns)
  vim.keymap.set('n', '<leader>hp', function()
    vscode.action('editor.action.dirtydiff.next')
  end, { desc = 'Preview hunk inline (VSCode)' })

  vim.keymap.set('n', '<leader>hP', function()
    vscode.action('git.openChange')
  end, { desc = 'Preview hunk side-by-side (VSCode)' })

  vim.keymap.set('n', '<leader>hr', function()
    vscode.action('git.revertSelectedRanges')
  end, { desc = 'Revert hunk (VSCode)' })

  vim.keymap.set('n', '<leader>hs', function()
    vscode.action('git.stageSelectedRanges')
  end, { desc = 'Stage hunk (VSCode)' })

  vim.keymap.set('n', '<leader>hu', function()
    vscode.action('git.unstageSelectedRanges')
  end, { desc = 'Unstage hunk (VSCode)' })

  -- Disable options that don't apply or conflict with VSCode
  vim.opt.list = false  -- VSCode handles whitespace display
  vim.opt.cursorline = false  -- VSCode handles cursor line highlight
  vim.opt.signcolumn = 'no'  -- VSCode handles the gutter
end
