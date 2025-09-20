return {
	"ggandor/leap.nvim",
	keys = { "s", "S" },  -- Only load when these keys are pressed
	config = function()
		require("leap").add_default_mappings()
		vim.keymap.del({ "x", "o" }, "x")
		vim.keymap.del({ "x", "o" }, "X")
	end,
}
