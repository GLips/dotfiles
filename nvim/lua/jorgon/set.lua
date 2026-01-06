-- General Neovim settings

-- Reduce delay for CursorHold events (affects LSP highlighting, swap file writes, etc.)
-- Default is 4000ms (4 seconds), setting to 300ms for faster LSP highlighting
vim.opt.updatetime = 300

-- Show line numbers
vim.opt.number = true
vim.opt.relativenumber = true

-- Enable mouse support
vim.opt.mouse = 'a'

-- Sync clipboard between OS and Neovim
-- Disabled: Only 'y' commands should yank to system clipboard (see remap.lua)
-- vim.opt.clipboard = 'unnamedplus'

-- Enable break indent
vim.opt.breakindent = true

-- Save undo history
vim.opt.undofile = true

-- Case-insensitive searching UNLESS \C or one or more capital letters in search term
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Keep signcolumn on by default (for git signs, LSP diagnostics, etc.)
vim.opt.signcolumn = 'yes'

-- Decrease mapped sequence wait time
-- Displays which-key popup sooner
vim.opt.timeoutlen = 200

-- Configure how new splits should be opened
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Preview substitutions live, as you type
vim.opt.inccommand = 'split'

-- Show which line your cursor is on
vim.opt.cursorline = true

-- Minimal number of screen lines to keep above and below the cursor
vim.opt.scrolloff = 10

-- Set terminal title to show filename (bubbles up through tmux to Ghostty tab)
vim.opt.title = true
vim.opt.titlestring = "%t%( %m%)" -- filename (and [+] if modified)
