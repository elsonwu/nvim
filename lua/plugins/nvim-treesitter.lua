return {
	"nvim-treesitter/nvim-treesitter",
	event = { "BufReadPost", "BufNewFile" },  -- More specific events
	build = ":TSUpdate",
	config = function()
		local configs = require("nvim-treesitter.configs")

		configs.setup({
			-- Pre-install only commonly used parsers for better performance
			ensure_installed = { "lua", "vim", "vimdoc", "javascript", "typescript", "json", "yaml", "markdown" },
			auto_install = false,  -- Disable auto-install for better performance
			autotag = { enable = true },
			indent = {
				enable = true,
				disable = { "yaml", "python" },  -- Disable for problematic languages
			},
			sync_install = false,
			highlight = {
				enable = true,
				additional_vim_regex_highlighting = false,  -- MAJOR performance killer - keep disabled
				-- Disable for very large files
				disable = function(lang, buf)
					local max_filesize = 100 * 1024 -- 100 KB
					local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
					if ok and stats and stats.size > max_filesize then
						return true
					end
					-- Also disable for very long lines to improve performance
					local max_lines = 5000
					local line_count = vim.api.nvim_buf_line_count(buf)
					if line_count > max_lines then
						return true
					end
					-- Disable for specific slow file types
					local slow_langs = { "latex", "tex" }
					if vim.tbl_contains(slow_langs, lang) then
						local lines = vim.api.nvim_buf_line_count(buf)
						if lines > 1000 then
							return true
						end
					end
				end,
			},
			-- Optimize incremental selection for performance
			incremental_selection = {
				enable = false,  -- Disable if not used
			},
			-- Optimize textobjects for performance  
			textobjects = {
				enable = false,  -- Disable if not using textobjects
			},
			-- Disable other expensive features if not used
			playground = {
				enable = false,
			},
			query_linter = {
				enable = false,
			},
		})

		-- Additional performance optimization for special file types
		vim.api.nvim_create_autocmd("FileType", {
			pattern = { "help", "alpha", "dashboard", "neo-tree", "Trouble", "lazy", "mason" },
			callback = function()
				vim.b.ts_highlight = false
			end,
		})

		vim.cmd("autocmd BufNewFile,BufRead *.avdl setfiletype java")
		vim.cmd("autocmd BufNewFile,BufRead *.mdx setfiletype markdown")
	end,
}
