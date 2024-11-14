return {
	enabled = true,
	"nvim-tree/nvim-tree.lua",
	-- cmd = "NvimTreeToggle",
	-- event = "UIEnter",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	opts = {
		auto_reload_on_write = true,
		disable_netrw = true,
		hijack_netrw = true,
		update_cwd = true,
		diagnostics = {
			enable = false, -- Disable diagnostics if not essential
		},
		sync_root_with_cwd = true,
		respect_buf_cwd = true,
		hijack_cursor = true,
		update_focused_file = {
			enable = true,
			update_root = true,
		},
		view = {
			adaptive_size = true,
		},
		git = {
			ignore = true,
			timeout = 1000,
		},
		hijack_directories = {
			enable = true,
			auto_open = true,
		},
		filesystem_watchers = {
			ignore_dirs = {
				"node_modules",
				".git",
				"__pycache__",
			},
		},
		-- filters = {
		-- 	dotfiles = false,
		-- 	custom = { ".git", "node_modules", "__pycache__" },
		-- },
		renderer = {
			highlight_git = false,
			highlight_opened_files = "none",
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
	},
}
