return {
	"dracula/vim",
	lazy = false,
	priority = 900,
	name = "dracula",
	config = function()
		vim.cmd("colorscheme dracula")
	end,
}
