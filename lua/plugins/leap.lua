return {
	"ggandor/leap.nvim",
	lazy = false,
	event = "UIEnter",
	config = function()
		require("leap").add_default_mappings()
		vim.keymap.del({ "x", "o" }, "x")
		vim.keymap.del({ "x", "o" }, "X")
	end,
}
