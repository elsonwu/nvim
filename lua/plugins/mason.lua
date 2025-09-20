return {
  "williamboman/mason.nvim",
  event = "VeryLazy", -- Change to VeryLazy for better startup performance
  lazy = true,
  build = ":MasonUpdate",
  opts = {
    ui = { 
      check_outdated_packages_on_open = false,
      border = "rounded",
      width = 0.8,
      height = 0.8,
    },
    max_concurrent_installers = 3, -- Limit concurrent installations
    providers = {
      "mason.providers.client",
      "mason.providers.registry-api",
    },
  },
}
