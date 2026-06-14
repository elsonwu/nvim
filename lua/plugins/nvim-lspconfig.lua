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

		local lsp_augroup = vim.api.nvim_create_augroup("lsp_events", { clear = true })

		-- Notify on attach so you know the server connected
		vim.api.nvim_create_autocmd("LspAttach", {
			group = lsp_augroup,
			callback = function(ev)
				local client = vim.lsp.get_client_by_id(ev.data.client_id)
				if not client then return end

				-- Detach from very large files (>1MB)
				local buf_name = vim.api.nvim_buf_get_name(ev.buf)
				local ok, stats = pcall(vim.uv.fs_stat, buf_name)
				if ok and stats and stats.size > 1024 * 1024 then
					vim.lsp.buf_detach_client(ev.buf, ev.data.client_id)
					vim.diagnostic.enable(false, { bufnr = ev.buf })
					return
				end

				vim.notify(client.name .. " attached", vim.log.levels.INFO)
			end,
		})

		-- Show LSP progress as notifications (debounced per client to reduce noise)
		local progress_timers = {}
		vim.api.nvim_create_autocmd("LspProgress", {
			group = lsp_augroup,
			callback = function(ev)
				local id = ev.data.client_id
				if progress_timers[id] then
					progress_timers[id]:stop()
					progress_timers[id]:close()
				end
				progress_timers[id] = vim.uv.new_timer()
				progress_timers[id]:start(200, 0, vim.schedule_wrap(function()
					progress_timers[id]:close()
					progress_timers[id] = nil
					local msg = vim.lsp.status()
					if msg ~= "" then
						vim.notify(msg, vim.log.levels.INFO)
					end
				end))
			end,
		})
	end,
}
