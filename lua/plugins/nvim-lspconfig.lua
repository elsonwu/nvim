return {
	"neovim/nvim-lspconfig",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		-- Format command
		vim.api.nvim_create_user_command("Format", function()
			vim.lsp.buf.format({ timeout_ms = 2000 })
		end, { desc = "Format file with LSP" })

		-- Reduce LSP log noise
		vim.lsp.log.set_level(vim.log.levels.ERROR)

		-- Consolidated diagnostic config (single source of truth)
		vim.diagnostic.config({
			virtual_text = {
				spacing = 4,
				source = 'if_many',
				prefix = '●',
			},
			signs = true,
			underline = true,
			update_in_insert = false,
			severity_sort = true,
			float = {
				focusable = false,
				style = "minimal",
				border = "single",
				source = "always",
				header = "",
				prefix = "",
				max_width = 80,
				max_height = 20,
			},
		})

		-- LSP floating window defaults
		vim.lsp.handlers["textDocument/hover"] = function(err, result, ctx, config)
			config = config or {}
			config.border = config.border or "single"
			config.max_width = config.max_width or 80
			config.max_height = config.max_height or 20
			return vim.lsp.handlers.hover(err, result, ctx, config)
		end

		vim.lsp.handlers["textDocument/signatureHelp"] = function(err, result, ctx, config)
			config = config or {}
			config.border = config.border or "single"
			config.max_width = config.max_width or 80
			config.max_height = config.max_height or 10
			return vim.lsp.handlers.signature_help(err, result, ctx, config)
		end

		-- Disable LSP for very large files (>1MB) on attach — LspAttach avoids the
		-- BufReadPre+schedule race where LSP starts indexing before the deferred detach runs
		local bigfile_augroup = vim.api.nvim_create_augroup("lsp_bigfile_guard", { clear = true })
		vim.api.nvim_create_autocmd("LspAttach", {
			group = bigfile_augroup,
			callback = function(ev)
				local bufnr = ev.buf
				local buf_name = vim.api.nvim_buf_get_name(bufnr)
				local ok, stats = pcall(vim.uv.fs_stat, buf_name)
				if ok and stats and stats.size > 1024 * 1024 then
					vim.lsp.buf_detach_client(bufnr, ev.data.client_id)
					vim.diagnostic.enable(false, { bufnr = bufnr })
				end
			end,
		})
	end,
}
