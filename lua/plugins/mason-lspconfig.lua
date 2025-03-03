return {
  lazy = true,
  "williamboman/mason-lspconfig.nvim",
  event = "VeryLazy",
  dependencies = { "williamboman/mason.nvim", "neovim/nvim-lspconfig" },
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
      ensure_installed = { "vtsls", "ts_ls", "jdtls", "yamlls", "lua_ls" },
    })

    local lspconfig = require("lspconfig")
    require("mason-lspconfig").setup_handlers({
      -- The first entry (without a key) will be the default handler
      -- and will be called for each installed server that doesn't have
      -- a dedicated handler.
      function(server_name) -- default handler (optional)
        lspconfig[server_name].setup({})
      end,

      ["ts_ls"] = function()
        if not node_major_version or node_major_version < 16 then
          lspconfig.ts_ls.setup({})
        end
      end,

      ["vtsls"] = function()
        if node_major_version and node_major_version >= 16 then
          lspconfig.vtsls.setup({
            capabilities = capabilities,
          })
        end
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
