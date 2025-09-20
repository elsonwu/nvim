return {
	"neovim/nvim-lspconfig",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = {
		"hrsh7th/cmp-nvim-lsp",
	},
	config = function()
		-- Create proper capabilities including formatting
		local capabilities = require('cmp_nvim_lsp').default_capabilities()
		
		-- Optimize capabilities for performance
		capabilities.textDocument.completion.completionItem.snippetSupport = true
		capabilities.textDocument.completion.completionItem.resolveSupport = {
			properties = { "documentation", "detail", "additionalTextEdits" }
		}
		
		-- Instead, set up a proper formatter command
		vim.api.nvim_create_user_command("Format", function()
			vim.lsp.buf.format({ timeout_ms = 2000 })
		end, { desc = "Format file with LSP" })
		
		-- Set up formatting on save if you want
		local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
		
		-- Setup proper handlers for LSP connections
		vim.api.nvim_create_autocmd("LspAttach", {
			group = augroup,
			callback = function(args)
				local client = vim.lsp.get_client_by_id(args.data.client_id)
				-- Only attach to clients that support document formatting
				if client and client.server_capabilities.documentFormattingProvider then
					-- You can uncomment this to enable format on save
					-- vim.api.nvim_clear_autocmds({ group = augroup, buffer = args.buf })
					-- vim.api.nvim_create_autocmd("BufWritePre", {
					--   group = augroup,
					--   buffer = args.buf,
					--   callback = function() vim.lsp.buf.format({ timeout_ms = 2000 }) end,
					-- })
				end
			end,
		})
		
		-- Optimize LSP performance
		vim.lsp.set_log_level("ERROR")  -- Reduce logging
		
		-- Major performance improvement: Optimize floating window handler
		local orig_util_open_floating_preview = vim.lsp.util.open_floating_preview
		function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
			opts = opts or {}
			opts.border = opts.border or "single"
			opts.max_width = opts.max_width or 80
			opts.max_height = opts.max_height or 20
			return orig_util_open_floating_preview(contents, syntax, opts, ...)
		end
		
		-- Configure diagnostics for major performance improvement
		vim.diagnostic.config({
			virtual_text = false,  -- Disable virtual text for major performance boost
			signs = true,
			underline = true,
			update_in_insert = false,  -- Don't update diagnostics in insert mode
			severity_sort = true,
			-- Optimize diagnostic performance
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
		
		-- Add selective debouncing for LSP operations (exclude references)
		local function setup_lsp_debounce()
			local timer = vim.loop.new_timer()
			local DEBOUNCE_DELAY = 150
			
			-- Methods that should NOT be debounced (need immediate response)
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
				-- Skip debouncing for critical navigation methods
				for _, no_debounce_method in ipairs(no_debounce_methods) do
					if method == no_debounce_method then
						return orig_buf_request(bufnr, method, params, handler)
					end
				end
				
				-- Apply debouncing for other methods
				timer:stop()
				timer:start(DEBOUNCE_DELAY, 0, vim.schedule_wrap(function()
					orig_buf_request(bufnr, method, params, handler)
				end))
			end
		end
		
		setup_lsp_debounce()
		
		-- Add timeout handling for references
		local orig_references = vim.lsp.buf.references
		vim.lsp.buf.references = function(context, options)
			options = options or {}
			options.timeout_ms = options.timeout_ms or 10000  -- 10 second timeout
			
			-- Add loading indicator
			local loading_msg = "🔍 Finding references..."
			vim.notify(loading_msg, vim.log.levels.INFO, { title = "LSP" })
			
			local orig_handler = vim.lsp.handlers["textDocument/references"]
			vim.lsp.handlers["textDocument/references"] = function(err, result, ctx, config)
				-- Clear loading notification
				vim.schedule(function()
					vim.cmd("echon ''")  -- Clear command line
				end)
				
				if err then
					vim.notify("References search failed: " .. (err.message or "Unknown error"), vim.log.levels.ERROR)
					return
				end
				
				if not result or #result == 0 then
					vim.notify("No references found", vim.log.levels.WARN)
					return
				end
				
				-- Restore original handler and call it
				vim.lsp.handlers["textDocument/references"] = orig_handler
				return orig_handler(err, result, ctx, config)
			end
			
			return orig_references(context, options)
		end
		
		-- Disable LSP for large files
		local function should_disable_lsp(bufnr)
			local buf_name = vim.api.nvim_buf_get_name(bufnr)
			local ok, stats = pcall(vim.loop.fs_stat, buf_name)
			
			if ok and stats and stats.size > 1024 * 1024 then -- 1MB
				return true
			end
			
			return false
		end
		
		-- Auto-disable LSP for large files
		vim.api.nvim_create_autocmd("BufReadPre", {
			callback = function()
				local bufnr = vim.api.nvim_get_current_buf()
				if should_disable_lsp(bufnr) then
					vim.schedule(function()
						vim.diagnostic.disable(bufnr)
						-- Detach LSP clients
						local clients = vim.lsp.get_active_clients({bufnr = bufnr})
						for _, client in ipairs(clients) do
							vim.lsp.buf_detach_client(bufnr, client.id)
						end
					end)
				end
			end,
		})
		
		-- Optimize LSP handlers for performance
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
