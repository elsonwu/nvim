return {
	"akinsho/bufferline.nvim",
	event = "VeryLazy",
	version = "*",
	opts = {
		options = {
			diagnostics = "nvim_lsp",
			diagnostics_indicator = function(count, level)
				local icon = level:match("error") and " " or ""
				return " " .. icon .. count
			end,
			separator_style = "thick",
			truncate_names = false, -- whether or not tab names should be truncated
			show_close_icon = false,
			show_buffer_icons = false, -- disable filetype icons for buffers
			show_buffer_close_icons = false,
			-- show_buffer_default_icon = true, -- whether or not an unrecognised filetype should show a default icon
		},
	},
	-- setup = function()
	-- 	require("bufferline").setup({
	-- options = {
	-- 	diagnostics = "nvim_lsp",
	-- 	diagnostics_indicator = function(count, level)
	-- 		local icon = level:match("error") and " " or ""
	-- 		return " " .. icon .. count
	-- 	end,
	-- 	separator_style = "thick",
	-- 	truncate_names = false, -- whether or not tab names should be truncated
	-- 	show_close_icon = false,
	-- 	show_buffer_icons = false, -- disable filetype icons for buffers
	-- 	show_buffer_close_icons = false,
	-- 	show_buffer_default_icon = true, -- whether or not an unrecognised filetype should show a default icon
	-- },
	-- 	})
	-- end,
	dependencies = "nvim-tree/nvim-web-devicons",
}
