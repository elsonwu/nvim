return {
  lazy = true,
  "williamboman/mason-lspconfig.nvim",
  event = "VeryLazy",
  dependencies = { "williamboman/mason.nvim", "neovim/nvim-lspconfig" },
  config = function()
    local capabilities = require('cmp_nvim_lsp').default_capabilities()
    
    -- Performance optimizations while preserving essential features
    capabilities.textDocument.completion.completionItem.snippetSupport = false
    capabilities.textDocument.completion.completionItem.preselectSupport = false
    capabilities.textDocument.completion.completionItem.insertReplaceSupport = false
    capabilities.textDocument.completion.completionItem.labelDetailsSupport = false
    capabilities.textDocument.completion.completionItem.deprecatedSupport = false
    capabilities.textDocument.completion.completionItem.commitCharactersSupport = false
    capabilities.textDocument.completion.completionItem.tagSupport = { valueSet = { 1 } }
    capabilities.textDocument.completion.completionItem.resolveSupport = {
      properties = {
        'documentation',
        'detail',
        'additionalTextEdits',
      }
    }
    
    -- Make sure to keep formatting capabilities
    -- This was missing from our optimizations, causing the error
    capabilities.textDocument.formatting = true
    capabilities.textDocument.documentFormatting = true
    capabilities.textDocument.documentRangeFormatting = true

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
        
        -- ESLint-specific configuration with library detection
        ["eslint"] = function()
          local lspconfig = require("lspconfig")
          
          lspconfig.eslint.setup({
            capabilities = capabilities,
            on_attach = function(client, bufnr)
              -- Only attach if project has ESLint configuration
              local root_dir = client.config.root_dir
              if root_dir then
                local eslintrc_files = {
                  ".eslintrc.js", ".eslintrc.json", ".eslintrc.yml", ".eslintrc.yaml",
                  "eslint.config.js", "eslint.config.mjs", "eslint.config.cjs"
                }
                local package_json = root_dir .. "/package.json"
                local has_eslint_config = false
                
                -- Check for ESLint config files
                for _, config_file in ipairs(eslintrc_files) do
                  if vim.fn.filereadable(root_dir .. "/" .. config_file) == 1 then
                    has_eslint_config = true
                    break
                  end
                end
                
                -- Check for ESLint in package.json
                if not has_eslint_config and vim.fn.filereadable(package_json) == 1 then
                  local ok, package_content = pcall(vim.fn.readfile, package_json)
                  if ok then
                    local package_str = table.concat(package_content, "\n")
                    if package_str:match('"eslint"') then
                      has_eslint_config = true
                    end
                  end
                end
                
                -- Detach if no ESLint configuration found
                if not has_eslint_config then
                  vim.schedule(function()
                    vim.lsp.buf_detach_client(bufnr, client.id)
                  end)
                  return
                end
              end
            end,
            settings = {
              workingDirectory = { mode = "auto" },
              format = { enable = true },
              lint = { enable = true },
              packageManager = "npm",
              codeActionOnSave = {
                enable = false,
                mode = "all"
              },
              run = "onType"
            },
            filetypes = {
              "javascript", "javascriptreact", "typescript", "typescriptreact",
              "vue", "svelte", "astro"
            },
          })
        end,
      }
    })

  end,
}
