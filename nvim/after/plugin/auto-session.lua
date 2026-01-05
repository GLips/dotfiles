-- Auto session - automatically save and restore sessions
local status_ok, auto_session = pcall(require, 'auto-session')
if not status_ok then
  return
end

auto_session.setup {
  log_level = 'error',
  auto_session_enable_last_session = false,
  auto_session_root_dir = vim.fn.stdpath('data').."/sessions/",
  auto_session_enabled = true,
  auto_save_enabled = true,
  auto_restore_enabled = true,
  auto_session_suppress_dirs = { "~/", "~/Downloads", "/", "/tmp" },
  auto_session_use_git_branch = false,
  
  -- Don't save fold settings - use config instead
  session_lens = {
    load_on_setup = true,
  },

  -- Critical: Allow args so it works when opening nvim in a directory
  auto_session_allowed_dirs = nil,
  bypass_session_save_file_types = { 'neo-tree' },

  -- Close Neo-tree before saving session to avoid issues
  pre_save_cmds = {
    function()
      -- Close all neo-tree windows before saving
      for _, win in ipairs(vim.api.nvim_list_wins()) do
        local buf = vim.api.nvim_win_get_buf(win)
        if vim.bo[buf].filetype == 'neo-tree' then
          vim.api.nvim_win_close(win, false)
        end
      end
    end
  },

  -- Reopen Neo-tree after restoring session
  post_restore_cmds = {
    function()
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
  },
}

-- Keybindings (using new AutoSession commands)
vim.keymap.set('n', '<leader>ss', ':SessionSave<CR>', { desc = 'Save session' })
vim.keymap.set('n', '<leader>sr', ':SessionRestore<CR>', { desc = 'Restore session' })
vim.keymap.set('n', '<leader>sd', ':SessionDelete<CR>', { desc = 'Delete session' })
vim.keymap.set('n', '<leader>sf', ':Autosession search<CR>', { desc = 'Search sessions' })
