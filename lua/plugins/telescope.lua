-- Replaced by fzf-lua (faster, leverages native fzf binary)
return {
  enabled = false,
  "nvim-telescope/telescope.nvim",
  cmd = "Telescope", -- Keeps lazy loading by command
  dependencies = {
    {"nvim-lua/popup.nvim", lazy = true},
    {"nvim-lua/plenary.nvim", lazy = true},
    {"nvim-telescope/telescope-fzf-native.nvim", build = "make", priority = 100}, -- Higher priority for the native sorter
    {"nvim-telescope/telescope-live-grep-args.nvim", version = "^1.0.0"},
    {"kkharji/sqlite.lua", lazy = true}, -- Add sqlite for better caching
    {"nvim-telescope/telescope-frecency.nvim", lazy = true}, -- Frecency-based history
  },
  config = function()
    local actions = require("telescope.actions")

    -- Performance optimizations
    local previewers = require("telescope.previewers")
    local new_maker = function(filepath, bufnr, opts)
      -- Don't preview large files (greater than 100kb)
      opts = opts or {}
      filepath = vim.fn.expand(filepath)
      local stat = vim.loop.fs_stat(filepath)
      if stat and stat.size > 100000 then
        return false
      else
        return previewers.buffer_previewer_maker(filepath, bufnr, opts)
      end
    end

    -- Create a custom finding function that uses ripgrep for better performance
    local custom_finder = function(opts)
      opts = opts or {}
      opts.find_command = {"rg", "--files", "--hidden", "-g", "!.git", "-g", "!node_modules"}
      return require('telescope.builtin').find_files(opts)
    end

    -- Expose the custom finder for keymaps
    _G.telescope_find_files_fast = custom_finder

    require("telescope").setup({
      pickers = {
        find_files = {
          hidden = true,
          find_command = { 
            "fd", 
            "--type", "f", 
            "--strip-cwd-prefix", 
            "--max-depth", "8", -- Limit search depth for performance
            "--exclude", ".git",
            "--exclude", "node_modules",
            "--exclude", "target",
            "--exclude", "build",
            "--exclude", "dist"
          },
          follow = true,  -- Follow symlinks
          results_title = false, -- Disable for performance
        },
        live_grep = {
          additional_args = function()
            return { 
              "--hidden", 
              "-g", "!.git", 
              "-g", "!node_modules",
              "--max-count", "300", -- Limit grep results for performance
              "--type-not", "lock",
              "--type-not", "log"
            }
          end,
          max_results = 500,  -- Reduce from 1000 for better performance
          results_title = false,
        },
        buffers = {
          ignore_current_buffer = true,
          sort_lastused = true,
          sort_mru = true,
          show_all_buffers = false, -- Only show loaded buffers
        },
        git_files = {
          show_untracked = false,  -- Faster git file search
        },
      },
      defaults = {
        buffer_previewer_maker = new_maker,
        preview = {
          check_mime_type = true,  -- Skip binary files
          filesize_limit = 0.1,   -- 100KB limit
          timeout = 250,          -- Preview timeout
        },
        file_ignore_patterns = { 
          "node_modules/.*", "dist/.*", "build/.*", "target/.*", "%.log", "%.tmp", "%.git/",
          "yarn%.lock", "package%-lock%.json", "%.min%.js", "%.min%.css",
          "%.DS_Store", "%.ico", "%.png", "%.jpg", "%.jpeg", "%.gif", "%.svg",
          "%.pdf", "%.zip", "%.tar%.gz", "%.class", "%.jar", "%.war", "%.ear",
          "__pycache__/.*", "%.pyc", "%.pyo", "%.lock"
        },
        layout_config = { 
          height = 0.85, 
          width = 0.85,
          preview_cutoff = 120,  -- Don't show preview for small windows
        },
        layout_strategy = "horizontal",  -- Horizontal is often faster
        prompt_prefix = "🔍 ",
        selection_caret = "➜ ",
        entry_prefix = "  ",
        path_display = { "truncate" },  -- Truncate is faster than filename_first
        color_devicons = true,
        set_env = { COLORTERM = "truecolor" },
        border = {},
        borderchars = { "─", "│", "─", "│", "┌", "┐", "┘", "└" },
        -- Performance settings
        cache_picker = {
          num_pickers = 3,  -- Reduce cache from default
          limit_entries = 500, -- Limit cached entries
        },
        dynamic_preview_title = false,  -- Disable for performance
        results_title = false,  -- Disable for performance
        sorting_strategy = "ascending", -- Faster than descending
        scroll_strategy = "cycle",
        mappings = {
          i = {
            ["<C-d>"] = actions.delete_buffer + actions.move_to_top, -- Delete buffer and move selection up
            ["<C-n>"] = function()
              vim.cmd("stopinsert")
            end, -- Switch to normal mode
            ["<C-o>"] = function(p_bufnr)
              require("telescope.actions").send_selected_to_qflist(p_bufnr)
              vim.cmd.cfdo("edit")
            end,
            ["<C-j>"] = actions.move_selection_next,
            ["<C-k>"] = actions.move_selection_previous,
            ["<CR>"] = actions.select_default,
          },
          n = {
            ["q"] = actions.close,
            ["d"] = actions.delete_buffer + actions.move_to_top, -- Delete buffer in normal mode
            ["<C-i>"] = function()
              vim.cmd("startinsert")
            end, -- Switch to insert mode
            ["<C-o>"] = function(p_bufnr)
              require("telescope.actions").send_selected_to_qflist(p_bufnr)
              vim.cmd.cfdo("edit")
            end,
          },
        },
      },
      extensions = {
        live_grep_args = {
          debounce = 200,      -- Delay in milliseconds before triggering search (e.g., 200ms)
          auto_quoting = true, -- enable/disable auto-quoting
        },
        fzf = {
          fuzzy = true,                   -- false will only do exact matching
          override_generic_sorter = true, -- override the generic sorter
          override_file_sorter = true,    -- override the file sorter
          case_mode = "smart_case",       -- or "ignore_case" or "respect_case"
        },
      },
    })

    require("telescope").load_extension("fzf")
    require("telescope").load_extension("live_grep_args")
  end,
}
