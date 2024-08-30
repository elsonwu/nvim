return {
	"williamboman/mason-lspconfig.nvim",
	-- event = "VeryLazy",
	dependencies = { "williamboman/mason.nvim" },
	config = function()
		require("mason-lspconfig").setup({
			automatic_installation = true,
			ensure_installed = {
				"tsserver",
				"rust_analyzer",
				"gopls",
				"lua_ls",
				"vimls",
				"jsonls",
				"yamlls",
			},
		})

		local lspconfig = require("lspconfig")
		require("mason-lspconfig").setup_handlers({
			-- The first entry (without a key) will be the default handler
			-- and will be called for each installed server that doesn't have
			-- a dedicated handler.
			function(server_name) -- default handler (optional)
				lspconfig[server_name].setup({})
			end,

			["tsserver"] = function()
				-- skip
			end,

			["yamlls"] = function()
				lspconfig.yamlls.setup({
					settings = {
						yaml = {
							schemas = require("schemastore").yaml.schemas(),
						},
					},
				})
			end,

			["jsonls"] = function()
				lspconfig.jsonls.setup({
					settings = {
						json = {
							schemas = require("schemastore").json.schemas(),
						},
					},
				})
			end,

			-- ["rust_analyzer"] = function()
			-- 	require("rust-tools").setup({})
			-- end,

			["lua_ls"] = function()
				lspconfig.lua_ls.setup({
					settings = {
						Lua = {
							diagnostics = {
								globals = { "vim" },
							},
						},
					},
				})
			end,
		})
	end,
}
