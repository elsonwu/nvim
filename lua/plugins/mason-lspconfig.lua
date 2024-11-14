return {
	"williamboman/mason-lspconfig.nvim",
	event = "UIEnter",
	dependencies = { "williamboman/mason.nvim" },
	config = function()
		local capabilities = vim.lsp.protocol.make_client_capabilities()
		capabilities.textDocument.completion.completionItem.snippetSupport = false -- Disable snippet support if not needed

		require("mason-lspconfig").setup({
			automatic_installation = true,
			ensure_installed = {
				"ts_ls",
				"vtsls",
				"jdtls",
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

			["vtsls"] = function()
				-- skip
			end,

			["ts_ls"] = function()
				lspconfig.ts_ls.setup({
					capabilities = capabilities,
					filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact", "mdx" }, -- Add 'mdx' here
					root_dir = lspconfig.util.root_pattern("package.json", "tsconfig.json", ".git"),
					settings = {
						completions = {
							completeFunctionCalls = true,
						},
					},
				})
			end,

			["jdtls"] = function()
				lspconfig.jdtls.setup({
					settings = {
						java = {
							configuration = {
								updateBuildConfiguration = "automatic",
							},
						},
					},
				})
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
