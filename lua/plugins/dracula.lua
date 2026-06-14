return {
	"Mofiqul/dracula.nvim",
	lazy = false,
	priority = 900,
	name = "dracula",
	config = function()
		vim.cmd("colorscheme dracula")
		-- Dracula defines SnacksPickerPathHidden but omits SnacksPickerPathIgnored,
		-- which falls back to invisible. Match hidden style with italic to distinguish.
		vim.api.nvim_set_hl(0, "SnacksPickerPathIgnored", { fg = "#6272A4", italic = true })
	end,
}
