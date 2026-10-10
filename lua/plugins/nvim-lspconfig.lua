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

				-- Once per client, not on every buffer it attaches to. Progress is
				-- shown by lualine (vim.lsp.status()), not as notifications.
				if vim.tbl_count(client.attached_buffers) == 1 then
					vim.notify(client.name .. " attached", vim.log.levels.INFO)
				end
			end,
		})
	end,
}
