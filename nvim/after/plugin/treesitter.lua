require('nvim-treesitter.configs').setup {
	-- Install parsers for these languages
	ensure_installed = {
		"javascript",
		"typescript",
		"tsx", -- TypeScript JSX
		"lua",
		"rust",
		"c",
		"json",
		"markdown",
		"markdown_inline",
		"html",
		"css"
	},

	-- Install parsers synchronously
	sync_install = false,

	-- Auto-install missing parsers when entering buffer
	auto_install = true,

	-- Disable highlighting in VSCode (VSCode handles syntax highlighting)
	highlight = {
		enable = not vim.g.vscode,
		additional_vim_regex_highlighting = false,
	},

	-- Text objects for functions, classes, parameters, etc.
	textobjects = {
		select = {
			enable = true,
			lookahead = true, -- Automatically jump forward to textobj

			keymaps = {
				-- Functions
				["af"] = "@function.outer",
				["if"] = "@function.inner",
				-- Classes
				["ac"] = "@class.outer",
				["ic"] = "@class.inner",
				-- Parameters/arguments
				["aa"] = "@parameter.outer",
				["ia"] = "@parameter.inner",
				-- Conditionals (if/else)
				["ai"] = "@conditional.outer",
				["ii"] = "@conditional.inner",
				-- Loops
				["al"] = "@loop.outer",
				["il"] = "@loop.inner",
			},

			selection_modes = {
				['@parameter.outer'] = 'v', -- charwise
				['@function.outer'] = 'V', -- linewise
				['@class.outer'] = 'V', -- linewise
			},
		},

		-- Move between functions, classes, etc.
		move = {
			enable = true,
			set_jumps = true, -- Set jumps in jumplist

			goto_next_start = {
				["]f"] = "@function.outer",
				["]]"] = "@class.outer",
				["]a"] = "@parameter.inner",
			},
			goto_next_end = {
				["]F"] = "@function.outer",
				["]["] = "@class.outer",
			},
			goto_previous_start = {
				["[f"] = "@function.outer",
				["[["] = "@class.outer",
				["[a"] = "@parameter.inner",
			},
			goto_previous_end = {
				["[F"] = "@function.outer",
				["[]"] = "@class.outer",
			},
		},
	},
}

-- Repeatable motions with ; and , (only in regular Neovim)
-- Flash uses clever-f style (f repeats f), so ; and , are free for treesitter
if not vim.g.vscode then
	local ts_repeat_move = require("nvim-treesitter.textobjects.repeatable_move")
	vim.keymap.set({ "n", "x", "o" }, ";", ts_repeat_move.repeat_last_move_next)
	vim.keymap.set({ "n", "x", "o" }, ",", ts_repeat_move.repeat_last_move_previous)
end
