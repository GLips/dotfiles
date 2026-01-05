require("obsidian").setup({
  workspaces = {
    {
      name = "personal",
      path = "~/Dropbox/Obsidan",
    },
  },

  daily_notes = {
    folder = "journal/daily",
    template = "Daily Plan"
  },

  templates = {
    folder = "templates"
  },

  -- Optional, configure key mappings
  mappings = {
    -- "Obsidian follow" - follow link in text
    ["gf"] = {
      action = function()
        return require("obsidian").util.gf_passthrough()
      end,
      opts = { noremap = false, expr = true, buffer = true },
    },
    -- Toggle check-boxes
    ["<leader>ch"] = {
      action = function()
        return require("obsidian").util.toggle_checkbox()
      end,
      opts = { buffer = true },
    },
  },

  -- Optional, customize how notes are named
  note_id_func = function(title)
    -- If title is given, use it as the filename
    if title ~= nil then
      return title
    else
      -- Otherwise use timestamp
      return tostring(os.time())
    end
  end,

  -- Disable automatic frontmatter
  disable_frontmatter = true,

  -- Optional, disable completion if you don't want wiki-link suggestions
  completion = {
    nvim_cmp = true,
    min_chars = 2,
  },

  -- Optional, configure how wiki links are handled
  follow_url_func = function(url)
    -- Open URLs in default browser
    vim.fn.jobstart({ "open", url })
  end,
})
