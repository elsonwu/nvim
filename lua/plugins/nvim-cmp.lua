return {
	"hrsh7th/nvim-cmp",
	-- event = "InsertEnter",
	dependencies = {
		-- 'hrsh7th/cmp-cmdline', -- command line
		"hrsh7th/cmp-buffer", -- buffer completions
		"hrsh7th/cmp-nvim-lua", -- nvim config completions
		"hrsh7th/cmp-nvim-lsp", -- lsp completions
		"hrsh7th/cmp-path", -- file path completions
	},
	config = function()
		-- CMP -- START
		local cmp = require("cmp")
		local lspkind = require("lspkind")
		local has_words_before = function()
			local line, col = unpack(vim.api.nvim_win_get_cursor(0))
			return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
		end

		cmp.setup({
			completion = {
				autocomplete = false,
			},
			formatting = {
				format = lspkind.cmp_format({
					mode = "symbol",
					maxwidth = 50,
				}),
			},
			mapping = {
				["<C-p>"] = cmp.mapping.select_prev_item(),
				["<C-n>"] = cmp.mapping.select_next_item(),
				["<C-d>"] = cmp.mapping.scroll_docs(-4),
				["<C-f>"] = cmp.mapping.scroll_docs(4),
				["<C-Space>"] = cmp.mapping.complete(),
				["<C-e>"] = cmp.mapping.close(),
				["<CR>"] = cmp.mapping.confirm({
					behavior = cmp.ConfirmBehavior.Insert,
					select = true,
				}),
				["<Tab>"] = cmp.mapping(function(fallback)
					if cmp.visible() then
						cmp.select_next_item()
					elseif has_words_before() then
						cmp.complete()
					else
						fallback()
					end
				end, {
					"i",
					"s",
				}),
				["<S-Tab>"] = cmp.mapping(function(fallback)
					if cmp.visible() then
						cmp.select_prev_item()
					else
						fallback()
					end
				end, {
					"i",
					"s",
				}),
			},
			sources = cmp.config.sources({
				{ name = "nvim_lsp", max_item_count = 15 }, -- Ensure LSP comes first
				{ name = "path", max_item_count = 5 }, -- Path completions
				{ name = "buffer", max_item_count = 5 }, -- Buffer completions
			}),
			sorting = {
				priority_weight = 2,
				comparators = {
					cmp.config.compare.offset,
					cmp.config.compare.exact,
					cmp.config.compare.score,
					cmp.config.compare.recently_used,
					cmp.config.compare.locality,
					cmp.config.compare.kind,
					cmp.config.compare.sort_text,
					cmp.config.compare.length,
					cmp.config.compare.order,
				},
			},
			experimental = {
				ghost_text = true,
			},
			window = {
				completion = cmp.config.window.bordered(),
				documentation = cmp.config.window.bordered(),
			},
		})
		-- CMP -- END
	end,
}
