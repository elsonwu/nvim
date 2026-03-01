return {
  "ibhagwan/fzf-lua",
  cmd = "FzfLua",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  keys = {
    { "<leader>sf", "<cmd>FzfLua files<CR>", desc = "Find files" },
    { "<leader>ss", "<cmd>FzfLua live_grep<CR>", desc = "Live grep" },
    { "<leader>sb", "<cmd>FzfLua buffers<CR>", desc = "Search buffers" },
    { "<leader>sg", "<cmd>FzfLua git_status<CR>", desc = "Git status" },
    { "<leader>sw", "<cmd>FzfLua grep_cword<CR>", desc = "Grep word under cursor" },
    { "<leader>sh", "<cmd>FzfLua help_tags<CR>", desc = "Help tags" },
    { "<leader>sd", "<cmd>FzfLua diagnostics_document<CR>", desc = "Document diagnostics" },
    { "<leader>sD", "<cmd>FzfLua diagnostics_workspace<CR>", desc = "Workspace diagnostics" },
    { "<leader>sr", "<cmd>FzfLua resume<CR>", desc = "Resume last search" },
    { "<leader>sc", "<cmd>FzfLua git_commits<CR>", desc = "Git commits" },
  },
  opts = {
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
      fd_opts = "--type f --hidden --exclude .git --exclude node_modules --exclude target --exclude build --exclude dist --max-depth 8",
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
