return {
  lazy = true,
  "williamboman/mason-lspconfig.nvim",
  event = "VeryLazy",
  dependencies = { "williamboman/mason.nvim", "neovim/nvim-lspconfig" },
  config = function()
    local capabilities = vim.lsp.protocol.make_client_capabilities()

    require("mason-lspconfig").setup({
      automatic_installation = true, -- Reinstating automatic installation for convenience
      ensure_installed = { "vtsls", "jdtls", "yamlls", "lua_ls", "eslint" },
      handlers = {
        -- Default handler for all servers
        function(server_name)
          require("lspconfig")[server_name].setup({
            capabilities = capabilities,
          })
        end,
        
        -- ESLint: only start if project has ESLint config
        ["eslint"] = function()
          local lspconfig = require("lspconfig")

          lspconfig.eslint.setup({
            capabilities = capabilities,
            -- Prevent server from starting if no ESLint config exists
            root_dir = function(fname)
              local eslint_configs = {
                ".eslintrc.js", ".eslintrc.json", ".eslintrc.yml", ".eslintrc.yaml",
                ".eslintrc.cjs", "eslint.config.js", "eslint.config.mjs", "eslint.config.cjs",
              }
              local util = require("lspconfig.util")
              return util.root_pattern(unpack(eslint_configs))(fname)
            end,
            settings = {
              workingDirectory = { mode = "auto" },
              format = { enable = true },
              lint = { enable = true },
              run = "onType",
            },
            filetypes = {
              "javascript", "javascriptreact", "typescript", "typescriptreact",
              "vue", "svelte", "astro",
            },
          })
        end,
      }
    })

  end,
}
