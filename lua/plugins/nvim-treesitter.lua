return {
	event = "BufRead",
	"nvim-treesitter/nvim-treesitter",
	build = ":TSUpdate",
	config = function()
		local configs = require("nvim-treesitter.configs")

		configs.setup({
			ensure_installed = false,
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
		})

		vim.cmd("autocmd BufNewFile,BufRead *.avdl setfiletype java")
		vim.cmd("autocmd BufNewFile,BufRead *.mdx setfiletype markdown")
	end,
}
