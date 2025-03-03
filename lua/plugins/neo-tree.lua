return {
  enabled = false,
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons",
    "MunifTanjim/nui.nvim",
  },
  cmd = { "Neotree" },
  keys = {
    { "<leader>wh", "<cmd>Neotree toggle<CR>", desc = "Toggle Neo-tree" },
    { "<leader>ff", "<cmd>Neotree focus<CR>",  desc = "Focus Neo-tree" },
  },
  opts = {
    close_if_last_window = true,
    popup_border_style = "rounded",

    enable_git_status = false,  -- Disable Git status tracking
    enable_diagnostics = false, -- Disable diagnostics

    filesystem = {
      filtered_items = {
        visible = false,
        hide_dotfiles = false,
        hide_gitignored = true,
        hide_by_name = { ".git", "node_modules", "__pycache__" },
      },
      follow_current_file = {
        enabled = true, -- Automatically focus on the current file
        leave_dirs_open = false,
      },
      hijack_netrw_behavior = "open_current", -- Open on the current file
    },

    window = {
      position = "left",         -- Position of the Neo-tree window
      width = 40,                -- Width of the Neo-tree window
      mappings = {
        ["<CR>"] = "open",       -- Open a file
        ["o"] = "open",          -- Open a file
        ["<BS>"] = "close_node", -- Close a folder
        ["h"] = "navigate_up",   -- Navigate up a directory
        ["l"] = "open",          -- Open a folder
        ["R"] = "refresh",       -- Refresh the tree
      },
    },

    default_component_configs = {
      indent = {
        with_markers = true,
        indent_size = 2,
        indent_markers = {
          last = "└",
          middle = "│",
          corner = "│",
          none = " ",
        },
      },
    },
  },
  -- Automatically update CWD when opening Neo-tree
  on_attach = function(bufnr)
    vim.api.nvim_create_autocmd("BufEnter", {
      callback = function()
        require("neo-tree.sources.filesystem").set_root(vim.fn.expand("%:p:h"))
      end,
    })
  end,
}
