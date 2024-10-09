return {
	enabled = true,
	"nvim-tree/nvim-tree.lua",
	-- cmd = "NvimTreeToggle",
	-- event = "UIEnter",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	opts = {
		sync_root_with_cwd = true,
		respect_buf_cwd = true,
		disable_netrw = true,
		hijack_cursor = true,
		update_focused_file = {
			enable = true,
			update_root = true,
		},
		view = {
			adaptive_size = true,
		},
		renderer = {
			group_empty = false,
			indent_markers = {
				enable = true,
				inline_arrows = true,
				icons = {
					corner = "└",
					edge = "│",
					item = "│",
					bottom = "─",
					none = " ",
				},
			},
		},
		git = {
			ignore = true,
		},
		filesystem_watchers = {
			ignore_dirs = {
				"node_modules",
			},
		},
		filters = { dotfiles = false },
	},
}
