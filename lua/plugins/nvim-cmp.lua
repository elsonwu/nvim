return {
  "hrsh7th/nvim-cmp",
  event = { "InsertEnter", "CmdlineEnter" },
  lazy = true,
  dependencies = {
    "hrsh7th/cmp-buffer",   -- buffer completions
    "hrsh7th/cmp-nvim-lua", -- nvim config completions
    "hrsh7th/cmp-nvim-lsp", -- lsp completions
    "hrsh7th/cmp-path",     -- file path completions
    "onsails/lspkind.nvim",
  },
  config = function()
    -- CMP -- START
    local cmp = require("cmp")
    local lspkind = require("lspkind")
    local unpack = table.unpack or unpack

    local has_words_before = function()
      local line, col = unpack(vim.api.nvim_win_get_cursor(0))
      if col == 0 then
        return false
      end
      local current_line = vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]
      return current_line:sub(col, col):match("%s") == nil
    end

    cmp.setup({
      performance = {
        debounce = 150,        -- Increase debounce for better performance
        throttle = 60,         -- Increase throttle time
        fetching_timeout = 200, -- Reduce timeout
        confirm_resolve_timeout = 80,
        async_budget = 1,      -- Limit async operations
        max_view_entries = 15, -- Reduce visible entries
      },
      completion = {
        autocomplete = { require('cmp.types').cmp.TriggerEvent.TextChanged },  -- Only trigger on text change
        keyword_length = 2,  -- Start completing after 2 characters
        keyword_pattern = [[\%(-\?\d\+\%(\.\d\+\)\?\|\h\w*\%(-\w*\)*\)]],
        completeopt = 'menu,menuone,noinsert,noselect',
      },
      formatting = {
        fields = { "kind", "abbr" }, -- Remove "menu" for performance
        format = lspkind.cmp_format({
          mode = "symbol_text",
          maxwidth = 40, -- Reduce from 50
          ellipsis_char = "...",
          before = function(_, vim_item)
            -- Truncate long completion items for performance
            if #vim_item.abbr > 25 then
              vim_item.abbr = string.sub(vim_item.abbr, 1, 25) .. "..."
            end
            return vim_item
          end,
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
        { 
          name = "nvim_lsp", 
          max_item_count = 15, -- Increase from 8 but still limit
          priority = 1000,
          keyword_length = 2,
        },
        { 
          name = "path", 
          max_item_count = 6, -- Increase from 3
          priority = 250,
          keyword_length = 2,
        },
      }, {
        { 
          name = "buffer", 
          max_item_count = 8, -- Increase from 3
          keyword_length = 3, 
          priority = 50,
          option = {
            get_bufnrs = function()
              local bufs = {}
              for _, win in ipairs(vim.api.nvim_list_wins()) do
                bufs[vim.api.nvim_win_get_buf(win)] = true
              end
              return vim.tbl_keys(bufs)
            end
          },
        },
      }),
      sorting = {
        priority_weight = 2,
        comparators = {
          cmp.config.compare.offset,
          cmp.config.compare.exact,
          cmp.config.compare.score,
          cmp.config.compare.order,
          cmp.config.compare.recently_used,
          cmp.config.compare.locality,
          cmp.config.compare.kind,
          cmp.config.compare.sort_text,
          cmp.config.compare.length,
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
    
    -- Disable cmp for large files for performance
    vim.api.nvim_create_autocmd("BufReadPre", {
      callback = function()
        local ok, stats = pcall(vim.loop.fs_stat, vim.fn.expand("%"))
        if ok and stats and stats.size > 1024 * 1024 then -- 1MB
          require('cmp').setup.buffer({ enabled = false })
        end
      end,
    })
    -- CMP -- END
  end,
}
