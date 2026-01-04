-- Neo-tree setup
require("neo-tree").setup({
  close_if_last_window = true,  -- Close Neo-tree if it's the last window
  popup_border_style = "rounded",
  enable_git_status = true,
  enable_diagnostics = true,

  window = {
    position = "left",
    width = 30,
    mappings = {
      -- Custom keybindings (most defaults work great!)
      ["t"] = "open_tabnew",
      ["v"] = "open_vsplit",
      ["s"] = "open_split",
      ["C"] = "set_root",  -- cd into directory
      ["-"] = "navigate_up",  -- go to parent directory
      ["f"] = "fuzzy_finder",  -- Built-in fuzzy finder!
      ["<space>"] = "none",  -- disable space in tree (keep it for leader)
    }
  },

  filesystem = {
    filtered_items = {
      hide_dotfiles = false,
      hide_gitignored = false,
    },
    follow_current_file = {
      enabled = true,  -- Automatically expand folders to show current file
      leave_dirs_open = false,
    },
    use_libuv_file_watcher = true,  -- Auto-refresh on file changes
  },

  default_component_configs = {
    git_status = {
      symbols = {
        added     = "✚",
        modified  = "",
        deleted   = "✖",
        renamed   = "󰁕",
        untracked = "",
        ignored   = "",
        unstaged  = "󰄱",
        staged    = "",
        conflict  = "",
      }
    },
  },
})

-- Ctrl+N to toggle Neo-tree
vim.keymap.set("n", "<C-n>", ":Neotree toggle<CR>", { silent = true })

-- Open Neo-tree by default when starting Neovim
vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    -- Only open if no file was specified
    if vim.fn.argc() == 0 then
      vim.cmd("Neotree show")
      -- Focus on the file window, not the tree
      vim.cmd('wincmd l')
    else
      vim.cmd("Neotree show")
      vim.cmd('wincmd l')
    end
  end,
})
