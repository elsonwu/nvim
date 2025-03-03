return {
  "nvim-telescope/telescope.nvim",
  branch = '0.1.x',
  -- event = "VeryLazy",
  cmd = "Telescope",
  -- lazy = true,
  dependencies = {
    "nvim-lua/popup.nvim",
    "nvim-lua/plenary.nvim",
    { "nvim-telescope/telescope-fzf-native.nvim",     build = "make" },
    { "nvim-telescope/telescope-live-grep-args.nvim", version = "^1.0.0" },
  },
  config = function()
    local actions = require("telescope.actions")

    require("telescope").setup({
      pickers = {
        find_files = {
          hidden = true
        }
      },
      defaults = {
        preview = true,
        file_ignore_patterns = { "node_modules", "dist", "build", "*.log", "*.tmp" },
        layout_config = { height = 0.95, width = 0.95 },
        layout_strategy = "vertical",
        prompt_prefix = "🔍 ",
        selection_caret = "➜ ",
        entry_prefix = "  ",
        path_display = { "filename_first" },
        color_devicons = true,
        set_env = { COLORTERM = "truecolor" }, -- default = nil,
        border = {},
        borderchars = { "─", "│", "─", "│", "┌", "┐", "┘", "└" },
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
            ["q"] = actions.close,
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
