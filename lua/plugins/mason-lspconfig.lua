return {
  lazy = true,
  "williamboman/mason-lspconfig.nvim",
  event = "VeryLazy",
  dependencies = { "williamboman/mason.nvim", "neovim/nvim-lspconfig", "saghen/blink.cmp" },
  config = function()
    -- Use blink.cmp capabilities (replaces cmp_nvim_lsp)
    local capabilities = require('blink.cmp').get_lsp_capabilities()

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
