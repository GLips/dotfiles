-- Git diff view with file panel
local status_ok, diffview = pcall(require, 'diffview')
if not status_ok then
  return
end

diffview.setup {
  diff_binaries = false, -- Show diffs for binaries
  enhanced_diff_hl = true, -- Use better diff highlighting
  use_icons = true, -- Requires nvim-web-devicons

  view = {
    -- Configure the layout
    default = {
      layout = "diff2_horizontal",
      winbar_info = true,
    },
    file_panel = {
      listing_style = "tree", -- One of 'list' or 'tree'
      tree_options = {
        flatten_dirs = true,
        folder_statuses = "only_folded",
      },
      win_config = {
        position = "left",
        width = 35,
      },
    },
  },

  file_panel = {
    win_config = {
      position = "left",
      width = 35,
    },
  },

  keymaps = {
    view = {
      -- Close the diffview
      ["q"] = "<Cmd>DiffviewClose<CR>",
      ["<Esc>"] = "<Cmd>DiffviewClose<CR>",
      -- Navigate files
      ["]f"] = "<Cmd>lua require('diffview.actions').select_next_entry()<CR>",
      ["[f"] = "<Cmd>lua require('diffview.actions').select_prev_entry()<CR>",
      -- Stage/unstage hunks
      ["<leader>hs"] = "<Cmd>lua require('gitsigns').stage_hunk()<CR>",
      ["<leader>hr"] = "<Cmd>lua require('gitsigns').reset_hunk()<CR>",
    },
    file_panel = {
      -- Navigate and select files
      ["j"] = "<Cmd>lua require('diffview.actions').next_entry()<CR>",
      ["k"] = "<Cmd>lua require('diffview.actions').prev_entry()<CR>",
      ["<cr>"] = "<Cmd>lua require('diffview.actions').select_entry()<CR>",
      ["o"] = "<Cmd>lua require('diffview.actions').select_entry()<CR>",
      ["<tab>"] = "<Cmd>lua require('diffview.actions').select_next_entry()<CR>",
      ["<s-tab>"] = "<Cmd>lua require('diffview.actions').select_prev_entry()<CR>",
      -- Stage/unstage files
      ["s"] = "<Cmd>lua require('diffview.actions').toggle_stage_entry()<CR>",
      ["S"] = "<Cmd>lua require('diffview.actions').stage_all()<CR>",
      ["u"] = "<Cmd>lua require('diffview.actions').unstage_all()<CR>",
      -- Git commit
      ["cc"] = "<Cmd>!git commit -v<CR>",
      -- Close diffview
      ["q"] = "<Cmd>DiffviewClose<CR>",
      ["<Esc>"] = "<Cmd>DiffviewClose<CR>",
      -- Refresh
      ["R"] = "<Cmd>lua require('diffview.actions').refresh_files()<CR>",
    },
  },
}

-- Toggle function for Ctrl+G
local function toggle_diffview()
  local lib = require('diffview.lib')
  local view = lib.get_current_view()

  if view then
    -- Diffview is open, close it and return to previous tab
    vim.cmd('DiffviewClose')
  else
    -- Diffview is closed, open it in a clean new tab
    -- Set flag to prevent Neo-tree from auto-opening
    vim.g.opening_diffview = true

    -- Open diffview in new tab (no empty buffer created)
    vim.cmd('tab DiffviewOpen')

    -- Clear flag after diffview opens
    vim.defer_fn(function()
      vim.g.opening_diffview = false
    end, 100)
  end
end

-- Keybindings to open diffview
vim.keymap.set('n', '<C-g>', toggle_diffview, { desc = 'Toggle git diff view in new tab' })
vim.keymap.set('n', '<leader>gd', ':tab DiffviewOpen<CR>', { desc = 'Git diff view (new tab)' })
vim.keymap.set('n', '<leader>gc', ':DiffviewClose<CR>', { desc = 'Close git diff view' })
vim.keymap.set('n', '<leader>gh', ':tab DiffviewFileHistory<CR>', { desc = 'Git file history (all files)' })
vim.keymap.set('n', '<leader>gf', ':tab DiffviewFileHistory %<CR>', { desc = 'Git file history (current file)' })
