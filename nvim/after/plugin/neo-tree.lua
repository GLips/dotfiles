if vim.g.vscode then return end

-- Neo-tree setup
require("neo-tree").setup({
  close_if_last_window = true,  -- Close Neo-tree if it's the last window
  popup_border_style = "rounded",
  enable_git_status = true,
  enable_diagnostics = true,

  -- Integration with snacks.nvim for smart renaming
  event_handlers = {
    {
      event = "file_moved",
      handler = function(data)
        require("snacks").rename.on_rename_file(data.source, data.destination)
      end,
    },
    {
      event = "file_renamed",
      handler = function(data)
        require("snacks").rename.on_rename_file(data.source, data.destination)
      end,
    },
  },

  window = {
    position = "left",
    width = 30,
    mappings = {
      -- Custom keybindings (most defaults work great!)
      -- ["t"] = "open_tabnew",
      ["v"] = "open_vsplit",
      ["s"] = "open_split",
      ["|"] = "open_vsplit",  -- Matching vim/tmux bindings
      ["="] = "open_split",   -- Matching vim/tmux bindings
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
        staged    = ".",
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
    -- Small delay to avoid session restore conflicts
    vim.defer_fn(function()
      vim.cmd("Neotree show")
      -- Focus on the file window, not the tree
      vim.cmd('wincmd l')
    end, 10)
  end,
})

-- When creating a new tab, open neo-tree and focus editor
vim.api.nvim_create_autocmd("TabNewEntered", {
  callback = function()
    -- Don't open Neo-tree if we're opening diffview
    if vim.g.opening_diffview then
      return
    end

    -- Check if neo-tree is already open in this new tab
    local neo_tree_open = false
    for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
      local buf = vim.api.nvim_win_get_buf(win)
      local ft = vim.api.nvim_buf_get_option(buf, 'filetype')
      if ft == 'neo-tree' then
        neo_tree_open = true
        break
      end
    end

    if not neo_tree_open then
      vim.cmd("Neotree show")
      -- Focus the editor window
      vim.schedule(function()
        for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
          local buf = vim.api.nvim_win_get_buf(win)
          local ft = vim.api.nvim_buf_get_option(buf, 'filetype')
          if ft ~= 'neo-tree' then
            vim.api.nvim_set_current_win(win)
            break
          end
        end
      end)
    end
  end,
})

-- When switching tabs, focus the editor window
vim.api.nvim_create_autocmd("TabEnter", {
  callback = function()
    -- Focus the editor window when switching tabs
    for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
      local buf = vim.api.nvim_win_get_buf(win)
      local ft = vim.api.nvim_buf_get_option(buf, 'filetype')
      if ft ~= 'neo-tree' then
        vim.api.nvim_set_current_win(win)
        break
      end
    end
  end,
})

-- Session management: Close neo-tree before saving session
vim.api.nvim_create_autocmd("VimLeavePre", {
  callback = function()
    -- Close all neo-tree windows before saving session
    for _, win in ipairs(vim.api.nvim_list_wins()) do
      local buf = vim.api.nvim_win_get_buf(win)
      if vim.bo[buf].filetype == 'neo-tree' then
        vim.api.nvim_win_close(win, false)
      end
    end
  end,
})

-- Reveal current file in neo-tree when switching buffers
vim.api.nvim_create_autocmd("BufEnter", {
  callback = function()
    -- Only reveal if the buffer is a normal file
    if vim.bo.buftype == "" and vim.fn.filereadable(vim.fn.expand("%")) == 1 then
      -- Check if neo-tree is open
      for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
        local buf = vim.api.nvim_win_get_buf(win)
        local ft = vim.api.nvim_buf_get_option(buf, 'filetype')
        if ft == 'neo-tree' then
          -- Neo-tree is open, it will auto-reveal due to follow_current_file setting
          return
        end
      end
    end
  end,
})
