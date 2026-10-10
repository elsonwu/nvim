return {
	"nvim-treesitter/nvim-treesitter",
	lazy = false,
	priority = 800, -- Load right after colorscheme (priority 900)
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

		-- Parsers this config relies on for highlighting and folds. install() is
		-- async and a no-op for parsers already present; deferred to VeryLazy to
		-- keep its module load (~7ms) off the startup path.
		vim.api.nvim_create_autocmd("User", {
			group = augroup,
			pattern = "VeryLazy",
			once = true,
			callback = function()
				require("nvim-treesitter").install({
					"json", "lua", "vim", "javascript", "typescript", "tsx",
					"kotlin", "swift", "java", "html", "css", "scss", "xml",
					"markdown", "markdown_inline", -- required by render-markdown
				})
			end,
		})

		-- Highlight + fold from the same parse tree. Must run with `buf` current
		-- (vim.wo[0][0] is :setlocal on the current window). Treesitter turns
		-- regex syntax off, so foldmethod=syntax would yield no folds here.
		local function start(buf)
			if pcall(vim.treesitter.start, buf) then
				vim.wo[0][0].foldmethod = "expr"
				vim.wo[0][0].foldexpr = "v:lua.vim.treesitter.foldexpr()"
			end
		end

		-- Enable treesitter highlight. No size guards here: snacks.bigfile owns
		-- large files (it sets filetype=bigfile, which has no parser), and a
		-- size cutoff below that only pushed mid-size files onto the slower
		-- regex-syntax path.
		vim.api.nvim_create_autocmd("FileType", {
			group = augroup,
			callback = function(args)
				local buf = args.buf

				-- Skip special filetypes
				local skip_ft = { "help", "alpha", "dashboard", "neo-tree", "Trouble", "lazy", "mason" }
				if vim.tbl_contains(skip_ft, args.match) then
					return
				end

				-- Enable treesitter highlighting and folds for this buffer
				start(buf)
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
					vim.api.nvim_buf_call(buf, function() start(buf) end)
				end
			end
		end
	end,
}
