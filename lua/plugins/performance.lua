return {
  {
    "lewis6991/impatient.nvim",
    priority = 1000, -- Load this plugin first
  },
  {
    "nathom/filetype.nvim", -- Faster filetype detection
    lazy = false, -- Load during startup
    priority = 100,
  },
}
