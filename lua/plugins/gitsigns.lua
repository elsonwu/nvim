return {
	"lewis6991/gitsigns.nvim",
	event = { "BufReadPost", "BufNewFile" },  -- More specific than VeryLazy
	opts = {
		-- Performance optimizations
		attach_to_untracked = false,  -- Don't attach to untracked files
		current_line_blame = false,   -- Disable current line blame for performance
		current_line_blame_opts = {
			delay = 1000,               -- Increase delay even more for performance
			ignore_whitespace = true,
		},
		max_file_length = 20000,      -- Reduce from 40000 for better performance
		preview_config = {
			border = 'single',
			style = 'minimal',
			relative = 'cursor',
			row = 0,
			col = 1
		},
		-- Optimize sign updates
		update_debounce = 300,        -- Increase debounce from 200
		-- Simplify signs for performance
		signs = {
			add          = { text = '+' },
			change       = { text = '~' },
			delete       = { text = '-' },
			topdelete    = { text = '^' },
			changedelete = { text = '~' },
			untracked    = { text = '?' },
		},
		-- Disable expensive features
		word_diff = false,
		watch_gitdir = {
			interval = 1000, -- Check less frequently
			follow_files = true
		},
	},
}
