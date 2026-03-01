-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out,                            "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- Set leader before loading lazy.nvim so mappings are correct
vim.g.mapleader = "\\"
vim.g.maplocalleader = "\\"

-- Load performance optimizations before plugins
require("performance").setup()

-- Setup lazy.nvim
require("lazy").setup("plugins", {
  change_detection = {
    notify = false,
  },
  install = { colorscheme = { "habamax" } },
  checker = { enabled = false },
  performance = {
    rtp = {
      disabled_plugins = {
        "2html_plugin", "getscript", "getscriptPlugin", "gzip",
        "logipat", "matchit", "matchparen", "netrw", "netrwPlugin",
        "netrwSettings", "netrwFileHandlers", "tar", "tarPlugin",
        "rrhelper", "spellfile_plugin", "vimball", "vimballPlugin",
        "zip", "zipPlugin", "tutor", "rplugin", "synmenu", "optwin",
        "osc52", "compiler", "bugreport", "ftplugin",
      },
    },
  },
})

require("startup-profile").setup()
require("settings")
require("keymappings")
