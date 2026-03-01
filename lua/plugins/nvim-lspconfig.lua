return {
	"neovim/nvim-lspconfig",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = {
		"saghen/blink.cmp",
	},
	config = function()
		-- Use blink.cmp capabilities (replaces cmp_nvim_lsp)
		local capabilities = require('blink.cmp').get_lsp_capabilities()

		-- Format command
		vim.api.nvim_create_user_command("Format", function()
			vim.lsp.buf.format({ timeout_ms = 2000 })
		end, { desc = "Format file with LSP" })

		-- Formatting on save (commented out, uncomment to enable)
		local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
		vim.api.nvim_create_autocmd("LspAttach", {
			group = augroup,
			callback = function(args)
				local client = vim.lsp.get_client_by_id(args.data.client_id)
				if client and client.server_capabilities.documentFormattingProvider then
					-- Uncomment to enable format on save:
					-- vim.api.nvim_clear_autocmds({ group = augroup, buffer = args.buf })
					-- vim.api.nvim_create_autocmd("BufWritePre", {
					--   group = augroup,
					--   buffer = args.buf,
					--   callback = function() vim.lsp.buf.format({ timeout_ms = 2000 }) end,
					-- })
				end
			end,
		})

		-- Reduce LSP log noise
		vim.lsp.set_log_level("ERROR")

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

		-- Timeout handling for references
		local orig_references = vim.lsp.buf.references
		vim.lsp.buf.references = function(context, options)
			options = options or {}
			options.timeout_ms = options.timeout_ms or 10000

			vim.notify("Finding references...", vim.log.levels.INFO, { title = "LSP" })

			local orig_handler = vim.lsp.handlers["textDocument/references"]
			vim.lsp.handlers["textDocument/references"] = function(err, result, ctx, config)
				vim.schedule(function()
					vim.cmd("echon ''")
				end)

				if err then
					vim.notify("References search failed: " .. (err.message or "Unknown error"), vim.log.levels.ERROR)
					return
				end

				if not result or #result == 0 then
					vim.notify("No references found", vim.log.levels.WARN)
					return
				end

				vim.lsp.handlers["textDocument/references"] = orig_handler
				return orig_handler(err, result, ctx, config)
			end

			return orig_references(context, options)
		end

		-- Auto-disable LSP for very large files (>1MB)
		vim.api.nvim_create_autocmd("BufReadPre", {
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

		-- Optimized LSP handlers
		vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(
			vim.lsp.handlers.hover, {
				border = "single",
				max_width = 80,
				max_height = 20,
			}
		)

		vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(
			vim.lsp.handlers.signature_help, {
				border = "single",
				max_width = 80,
				max_height = 10,
			}
		)
	end,
}
