return {
	"nvim-treesitter/nvim-treesitter",
	event = { "BufReadPost", "BufNewFile" },
	cmd = { "TSInstall", "TSUpdate" },
	build = ":TSUpdate",
	config = function()
		require("nvim-treesitter").setup({})
		local augroup = vim.api.nvim_create_augroup("nvim_treesitter_custom", { clear = true })

		-- v1.0 removed :TSInstall/:TSUpdate commands, re-add them
		vim.api.nvim_create_user_command("TSInstall", function(opts)
			require("nvim-treesitter").install(opts.fargs)
		end, { nargs = "+", desc = "Install treesitter parsers" })

		vim.api.nvim_create_user_command("TSUpdate", function(opts)
			if #opts.fargs > 0 then
				require("nvim-treesitter").update(opts.fargs)
			else
				require("nvim-treesitter").update()
			end
		end, { nargs = "*", desc = "Update treesitter parsers" })

		-- Enable treesitter highlight with large-file guards
		vim.api.nvim_create_autocmd("FileType", {
			group = augroup,
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

		-- Enable treesitter-based indentation for supported filetypes
		vim.api.nvim_create_autocmd("FileType", {
			group = augroup,
			pattern = { "lua", "javascript", "typescript", "typescriptreact", "json", "markdown", "swift", "kotlin" },
			callback = function()
				vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
			end,
		})

		-- Retroactively apply to buffers already loaded before this plugin initialized
		-- (fixes race: FileType fires before BufReadPost triggers plugin load)
		for _, buf in ipairs(vim.api.nvim_list_bufs()) do
			if vim.api.nvim_buf_is_loaded(buf) and vim.bo[buf].filetype ~= "" then
				local ft = vim.bo[buf].filetype
				if not vim.tbl_contains({ "help", "alpha", "dashboard", "neo-tree", "Trouble", "lazy", "mason" }, ft) then
					pcall(vim.treesitter.start, buf)
				end
			end
		end
	end,
}
