return {
	"glepnir/lspsaga.nvim",
	branch = "main",
	event = "BufRead",
	dependencies = {
		{ "williamboman/mason-lspconfig.nvim", "neovim/nvim-lspconfig" },
	},
	opts = {
		request_timeout = 5000,
	},
}
