return {
	-- enabled = false,
	"williamboman/mason-lspconfig.nvim",
	-- event = "UIEnter",
	event = "VeryLazy",
	dependencies = { "williamboman/mason.nvim" },
	config = function()
		local capabilities = vim.lsp.protocol.make_client_capabilities()

		-- Helper function to parse Node.js version
		local function get_node_major_version()
			local version_output = vim.fn.system("node --version") -- e.g. "v16.13.0"
			-- Extract the digit part only (removing the 'v')
			local version = version_output:match("%d+%.%d+%.%d+")
			if not version then
				return nil
			end
			local major = version:match("^(%d+)")
			return tonumber(major)
		end

		local node_major_version = get_node_major_version()

		capabilities.textDocument.completion.completionItem.snippetSupport = false -- Disable snippet support if not needed

		require("mason-lspconfig").setup({
			automatic_installation = true,
			ensure_installed = { "vtsls", "ts_ls", "jdtls", "yamlls", "jsonls", "lua_ls" },
		})

		local lspconfig = require("lspconfig")
		require("mason-lspconfig").setup_handlers({
			-- The first entry (without a key) will be the default handler
			-- and will be called for each installed server that doesn't have
			-- a dedicated handler.
			function(server_name) -- default handler (optional)
				if server_name == "vtsls" then
					if node_major_version and node_major_version >= 16 then
						lspconfig.vtsls.setup({})
					end
				elseif server_name == "ts_ls" then
					if not node_major_version or node_major_version < 16 then
						lspconfig.ts_ls.setup({})
					end
				else
					lspconfig[server_name].setup({})
				end
			end,

			-- ["vtsls"] = function()

			-- end,

			-- ["ts_ls"] = function()
			-- lspconfig.ts_ls.setup({
			-- 	capabilities = capabilities,
			-- 	filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact", "mdx" }, -- Add 'mdx' here
			-- 	root_dir = lspconfig.util.root_pattern("package.json", "tsconfig.json", ".git"),
			-- 	settings = {
			-- 		completions = {
			-- 			completeFunctionCalls = true,
			-- 		},
			-- 		typescript = {
			-- 			exclude = { "**/node_modules", "**/.git" },
			-- 		},
			-- 		javascript = {
			-- 			exclude = { "**/node_modules", "**/.git" },
			-- 		},
			-- 	},
			-- })
			-- end,

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
