return {
	"nvim-treesitter/nvim-treesitter",
	event = "VeryLazy",
	build = ":TSUpdate",
	opt = {
		ensure_installed = "all",
		auto_install = true,
		autotag = { enable = true },
		indent = {
			enable = true,
			-- disable = { "yaml" },
		},
		sync_install = false,
		highlight = {
			enable = true,
			additional_vim_regex_highlighting = false,
		},
	},
	config = function()
		vim.cmd("autocmd BufNewFile,BufRead *.avdl setfiletype java")
	end,
}
