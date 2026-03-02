return {
	"nvim-treesitter/nvim-treesitter",
	event = { "BufReadPost", "BufNewFile" },
	cmd = { "TSInstall", "TSUpdate" },
	build = ":TSUpdate",
	config = function()
		require("nvim-treesitter").setup({})

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
			pattern = { "lua", "javascript", "typescript", "typescriptreact", "json", "markdown" },
			callback = function()
				vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
			end,
		})
	end,
}
