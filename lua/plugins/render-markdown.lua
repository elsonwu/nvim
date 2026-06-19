local function follow_md_link()
  local line = vim.api.nvim_get_current_line()
  local col = vim.api.nvim_win_get_cursor(0)[2] + 1

  local path = nil

  -- 1. Backtick span: `path/to/file`
  local pos = 1
  while not path do
    local ms, me, p = line:find("`([^`]+)`", pos)
    if not ms then break end
    if col >= ms and col <= me then path = p end
    pos = me + 1
  end

  -- 2. Markdown link: [label](path) or ![alt](path)
  if not path then
    pos = 1
    while not path do
      local ms, me, p = line:find("%!?%[[^%]]*%]%(([^%)]+)%)", pos)
      if not ms then break end
      if col >= ms and col <= me then path = p end
      pos = me + 1
    end
  end

  -- 3. Bare path under cursor (same logic as built-in gf)
  if not path or path == "" then
    path = vim.fn.expand("<cfile>")
  end

  if not path or path == "" then
    vim.lsp.buf.definition()
    return
  end

  -- Resolve relative to current file's directory
  if not vim.startswith(path, "/") and not path:match("^%a+://") then
    path = vim.fn.expand("%:p:h") .. "/" .. path
  end

  vim.cmd("edit " .. vim.fn.fnameescape(path))
end

return {
  "MeanderingProgrammer/render-markdown.nvim",
  dependencies = { "nvim-treesitter/nvim-treesitter" },
  ft = { "markdown" },
  opts = {
    render_modes = { "n", "c" },
  },
  config = function(_, opts)
    require("render-markdown").setup(opts)

    vim.api.nvim_create_autocmd("FileType", {
      group = vim.api.nvim_create_augroup("md_keymaps", { clear = true }),
      pattern = "markdown",
      callback = function()
        vim.keymap.set("n", "gd", follow_md_link, { buffer = 0, silent = true, desc = "Follow markdown link" })
      end,
    })
  end,
}
