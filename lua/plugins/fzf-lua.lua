return {
  "ibhagwan/fzf-lua",
  cmd = "FzfLua",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  keys = {
    { "<leader>sf", "<cmd>FzfLua files<CR>", desc = "Find files" },
    { "<leader>ss", "<cmd>FzfLua live_grep<CR>", desc = "Live grep" },
    { "<leader>sb", "<cmd>FzfLua buffers<CR>", desc = "Search buffers" },
    { "<leader>sg", "<cmd>FzfLua git_status<CR>", desc = "Git status" },
    { "<leader>sw", function() require("fzf-lua").live_grep({ search = vim.fn.expand("<cword>") }) end, desc = "Live grep word under cursor (editable)" },
    { "<leader>sP", function()
        vim.ui.input({ prompt = "Grep in dir: ", completion = "dir", default = vim.fn.expand("%:p:h") }, function(dir)
          if dir and dir ~= "" then require("fzf-lua").live_grep({ cwd = dir }) end
        end)
      end, desc = "Live grep in dir" },
    { "<leader>sw", mode = "x", function()
        vim.cmd('noau normal! "vy"')
        require("fzf-lua").live_grep({ search = vim.fn.getreg("v") })
      end, desc = "Live grep visual selection (editable)" },
    { "<leader>sh", "<cmd>FzfLua help_tags<CR>", desc = "Help tags" },
    { "<leader>sd", "<cmd>FzfLua diagnostics_document<CR>", desc = "Document diagnostics" },
    { "<leader>sD", "<cmd>FzfLua diagnostics_workspace<CR>", desc = "Workspace diagnostics" },
    { "<leader>sr", "<cmd>FzfLua resume<CR>", desc = "Resume last search" },
    { "<leader>sc", "<cmd>FzfLua git_commits<CR>", desc = "Git commits" },
    { "<leader>SF", function() require("fzf-lua").files({ fd_opts = "--type f --hidden --no-ignore --exclude .git" }) end, desc = "Find files (include ignored)" },
    { "<leader>sS", function() require("fzf-lua").live_grep({ rg_opts = "--column --line-number --no-heading --color=always --smart-case --hidden --no-ignore -g '!.git/'" }) end, desc = "Grep all (include ignored)" },
  },
  opts = {
    -- Show filename FIRST, dir dimmed + trailing (VSCode-style). Without this,
    -- fzf-lua leads with the full relative path; deep trees (e.g. Java
    -- src/main/java/.../datasources/) share an identical prefix and the unique
    -- filename gets truncated off-screen. Applies to files/grep/LSP/lsp_finder.
    formatter = "path.filename_first",
    winopts = {
      height = 0.85,
      width = 0.85,
      border = "single",
      preview = {
        default = "builtin",
        delay = 100,
        scrollbar = false,
      },
    },
    files = {
      fd_opts = "--type f --hidden --exclude .git --exclude node_modules --exclude target --exclude build --exclude dist",
      follow = true,
    },
    grep = {
      rg_opts = "--hidden --column --line-number --no-heading --color=always --smart-case -g '!.git' -g '!node_modules' --max-count 300",
    },
    buffers = {
      sort_lastused = true,
      ignore_current_buffer = true,
    },
    git = {
      status = {
        preview_pager = false,
      },
    },
    fzf_opts = {
      ["--layout"] = "reverse",
    },
    keymap = {
      builtin = {
        ["<C-d>"] = "preview-page-down",
        ["<C-u>"] = "preview-page-up",
      },
      fzf = {
        ["ctrl-q"] = "select-all+accept",
      },
    },
    -- Skip previewing large files
    previewers = {
      builtin = {
        limit_b = 100 * 1024, -- 100KB
      },
    },
  },
}
