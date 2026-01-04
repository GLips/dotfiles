require('nvim-treesitter.configs').setup {
	-- Install parsers for these languages
	ensure_installed = {
		"javascript",
		"typescript",
		"tsx",        -- TypeScript JSX
		"lua",
		"rust",
		"c",
		"json",
		"html",
		"css"
	},

	-- Install parsers synchronously
	sync_install = false,

	-- Auto-install missing parsers when entering buffer
	auto_install = true,

	highlight = {
		enable = true,
		additional_vim_regex_highlighting = false,
	},
}
