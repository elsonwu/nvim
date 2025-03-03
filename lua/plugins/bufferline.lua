return {
  -- enabled = false,
	"akinsho/bufferline.nvim",
	dependencies = "nvim-tree/nvim-web-devicons",
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
		},
	},
}
