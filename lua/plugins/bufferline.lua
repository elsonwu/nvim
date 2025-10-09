return {
	"akinsho/bufferline.nvim",
	dependencies = "nvim-tree/nvim-web-devicons",
	event = "VeryLazy",
	version = "*",
	opts = {
		options = {
			mode = "buffers",
			numbers = "none",
			diagnostics = false,
			diagnostics_update_in_insert = false,
			separator_style = "thin",
			truncate_names = true,
			max_name_length = 15,
			max_prefix_length = 10,
			tab_size = 15,
			show_close_icon = false,
			show_buffer_icons = false,
			show_buffer_close_icons = false,
			show_tab_indicators = false,
			always_show_bufferline = false,
			offsets = {},
			sort_by = "id",
			hover = {
				enabled = false,
			},
		},
	},
}
