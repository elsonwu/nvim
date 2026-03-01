return {
	"nvim-treesitter/nvim-treesitter",
	event = { "BufReadPost", "BufNewFile" },
	build = ":TSUpdate",
	config = function()
		-- nvim-treesitter v1.0+ API: setup() only accepts install_dir
		require("nvim-treesitter").setup({})

		-- Ensure common parsers are installed
		local ensure = { "lua", "vim", "vimdoc", "javascript", "typescript", "json", "yaml", "markdown" }
		local installed = require("nvim-treesitter").get_installed()
		local missing = vim.tbl_filter(function(lang)
			return not vim.tbl_contains(installed, lang)
		end, ensure)
		if #missing > 0 then
			require("nvim-treesitter").install(missing)
		end

		-- Enable treesitter highlight with large-file guards
		vim.api.nvim_create_autocmd("FileType", {
			callback = function(args)
				local buf = args.buf

				-- Skip special filetypes
				local skip_ft = { "help", "alpha", "dashboard", "neo-tree", "Trouble", "lazy", "mason" }
				if vim.tbl_contains(skip_ft, args.match) then
					return
				end

				-- Skip large files (>100KB)
				local ok, stats = pcall(vim.uv.fs_stat, vim.api.nvim_buf_get_name(buf))
				if ok and stats and stats.size > 100 * 1024 then
					return
				end

				-- Skip files with >5000 lines
				if vim.api.nvim_buf_line_count(buf) > 5000 then
					return
				end

				-- Enable treesitter highlighting for this buffer
				pcall(vim.treesitter.start, buf)
			end,
		})

		-- Enable treesitter-based indentation
		vim.api.nvim_create_autocmd("FileType", {
			pattern = { "lua", "javascript", "typescript", "json", "markdown" },
			callback = function()
				vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
			end,
		})
	end,
}
