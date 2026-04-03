return {
	"neovim/nvim-lspconfig",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		local capabilities = vim.lsp.protocol.make_client_capabilities()

		-- Format command
		vim.api.nvim_create_user_command("Format", function()
			vim.lsp.buf.format({ timeout_ms = 2000 })
		end, { desc = "Format file with LSP" })

		-- Reduce LSP log noise
		vim.lsp.log.set_level(vim.log.levels.ERROR)

		-- Optimize floating window handler
		local orig_util_open_floating_preview = vim.lsp.util.open_floating_preview
		function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
			opts = opts or {}
			opts.border = opts.border or "single"
			opts.max_width = opts.max_width or 80
			opts.max_height = opts.max_height or 20
			return orig_util_open_floating_preview(contents, syntax, opts, ...)
		end

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

		-- Selective debouncing for LSP operations
		local function setup_lsp_debounce()
			local timer = vim.uv.new_timer()
			local DEBOUNCE_DELAY = 150

			-- Methods that need immediate response (no debounce)
			local no_debounce_methods = {
				"textDocument/references",
				"textDocument/definition",
				"textDocument/typeDefinition",
				"textDocument/implementation",
				"textDocument/documentSymbol",
				"workspace/symbol"
			}

			local orig_buf_request = vim.lsp.buf_request
			vim.lsp.buf_request = function(bufnr, method, params, handler)
				for _, no_debounce_method in ipairs(no_debounce_methods) do
					if method == no_debounce_method then
						return orig_buf_request(bufnr, method, params, handler)
					end
				end
				timer:stop()
				timer:start(DEBOUNCE_DELAY, 0, vim.schedule_wrap(function()
					orig_buf_request(bufnr, method, params, handler)
				end))
			end
		end

		setup_lsp_debounce()

		-- Auto-disable LSP for very large files (>1MB)
		local bigfile_augroup = vim.api.nvim_create_augroup("lsp_bigfile_guard", { clear = true })
		vim.api.nvim_create_autocmd("BufReadPre", {
			group = bigfile_augroup,
			callback = function()
				local bufnr = vim.api.nvim_get_current_buf()
				local buf_name = vim.api.nvim_buf_get_name(bufnr)
				local ok, stats = pcall(vim.uv.fs_stat, buf_name)

				if ok and stats and stats.size > 1024 * 1024 then
					vim.schedule(function()
						vim.diagnostic.enable(false, { bufnr = bufnr })
						local clients = vim.lsp.get_clients({ bufnr = bufnr })
						for _, client in ipairs(clients) do
							vim.lsp.buf_detach_client(bufnr, client.id)
						end
					end)
				end
			end,
		})

		-- Optimized LSP handlers (Neovim 0.11+ API)
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
	end,
}
