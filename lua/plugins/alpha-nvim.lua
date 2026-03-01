-- Replaced by snacks.nvim dashboard
return {
	enabled = false,
	"goolord/alpha-nvim",
	event = "VimEnter", -- More specific than BufEnter
	dependencies = { {"nvim-tree/nvim-web-devicons", lazy = true} },
	config = function()
		local startify = require("alpha.themes.startify")

		startify.section.top_buttons.val = {
			startify.button("i", "  New file", ":ene <BAR> startinsert <CR>"),
			startify.file_button("~/www/", "w"),
			startify.file_button("~/.config/nvim/", "n"),
			startify.file_button("~/.config/fish/", "f"),
			startify.file_button("~/.npmrc", "np"),
		}

		require("alpha").setup(startify.opts)
	end,
}
