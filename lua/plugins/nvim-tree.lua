return {
	-- enabled = false,
	"nvim-tree/nvim-tree.lua",
	-- cmd = "NvimTreeToggle",
	-- event = "UIEnter",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	opts = {
		auto_reload_on_write = false,
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
			adaptive_size = false,
			float = {
				enable = true,
				open_win_config = {
					relative = "editor",
					border = "rounded",
					width = 80,
					height = 30,
					row = 2,
					col = 5,
				},
			},
		},
		git = {
			enable = false,
			ignore = true,
			timeout = 1000,
		},
		hijack_directories = {
			enable = true,
			auto_open = true,
		},
		filesystem_watchers = {
			enable = false,
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
		log = {
			enable = false,
			truncate = true,
			types = {
				all = false,
				config = false,
				copy_paste = false,
				dev = false,
				diagnostics = true,
				git = true,
				profile = true,
				watcher = true,
			},
		},
	},
}
