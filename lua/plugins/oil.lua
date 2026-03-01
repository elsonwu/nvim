return {
  "stevearc/oil.nvim",
  cmd = "Oil",
  keys = {
    { "-", "<cmd>Oil<CR>", desc = "Open parent directory (Oil)" },
  },
  opts = {
    default_file_explorer = false, -- Keep nvim-tree as default
    view_options = {
      show_hidden = true,
    },
    float = {
      padding = 2,
      max_width = 80,
      max_height = 30,
      border = "rounded",
    },
    keymaps = {
      ["q"] = "actions.close",
      ["<CR>"] = "actions.select",
      ["-"] = "actions.parent",
      ["_"] = "actions.open_cwd",
      ["g."] = "actions.toggle_hidden",
    },
  },
}
