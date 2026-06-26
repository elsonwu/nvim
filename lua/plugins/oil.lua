local function find_main_win()
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    if vim.api.nvim_win_get_config(win).relative == "" then
      return win
    end
  end
end

local function fzf_in_main_win(opts)
  local main_win = find_main_win()
  opts.actions = {
    ["default"] = function(selected, o)
      if main_win then vim.api.nvim_set_current_win(main_win) end
      require("fzf-lua").actions.file_edit(selected, o)
    end,
  }
  require("fzf-lua").files(opts)
end

return {
  "stevearc/oil.nvim",
  cmd = "Oil",
  keys = {
    { "-", "<cmd>Oil<CR>", desc = "Open parent directory (Oil)" },
    { "<leader>wh", function() require("oil").toggle_float(vim.fn.getcwd()) end, desc = "Oil: project root (float)" },
    { "<leader>ff", function() require("oil").toggle_float(vim.fn.expand("%:p:h")) end, desc = "Oil: current file dir (float)" },
  },
  init = function()
    vim.api.nvim_create_autocmd("BufModifiedSet", {
      pattern = "oil://*",
      callback = function(ev)
        local winbar = vim.bo[ev.buf].modified
          and "%#DiagnosticWarn#● unsaved — :w to apply, :e to discard%*"
          or ""
        for _, win in ipairs(vim.fn.win_findbuf(ev.buf)) do
          vim.wo[win].winbar = winbar
        end
      end,
    })

    vim.api.nvim_create_autocmd("VimEnter", {
      once = true,
      callback = function()
        if vim.fn.argc() == 1 and vim.fn.isdirectory(vim.fn.argv(0)) == 1 then
          vim.schedule(function()
            require("oil").toggle_float(vim.fn.argv(0))
          end)
        end
      end,
    })
  end,
  opts = {
    default_file_explorer = false,
    skip_confirm_for_simple_edits = true,
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
      ["<Esc>"] = "actions.close",
      ["<CR>"] = "actions.select",
      ["-"] = "actions.parent",
      ["_"] = "actions.open_cwd",
      ["g."] = "actions.toggle_hidden",
      ["gs"] = function() require("flash").jump() end,
      ["<leader>sf"] = function()
        fzf_in_main_win({ cwd = require("oil").get_current_dir() })
      end,
      ["<leader>SF"] = function()
        fzf_in_main_win({ cwd = require("oil").get_current_dir(), fd_opts = "--type f --hidden --no-ignore --exclude .git" })
      end,
    },
  },
}
