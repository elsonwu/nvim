return {
  "MagicDuck/grug-far.nvim",
  cmd = "GrugFar",
  keys = {
    { "<leader>S", function() require("grug-far").open() end, desc = "Search and replace (grug-far)" },
    { "<leader>S", function()
      require("grug-far").open({ prefills = { search = vim.fn.expand("<cword>") } })
    end, mode = "v", desc = "Search selection (grug-far)" },
  },
  opts = {
    headerMaxWidth = 80,
    debounceMs = 500,
    maxWorkers = 4,
    engines = {
      ripgrep = {
        extraArgs = "--hidden -g !.git -g !node_modules",
      },
    },
  },
}
