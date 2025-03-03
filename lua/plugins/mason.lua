return {
  "williamboman/mason.nvim",
  event = "BufReadPre",
  lazy = true,
  build = ":MasonUpdate",
  opts = {
    ui = { check_outdated_packages_on_open = false },
    providers = {
      "mason.providers.client",
      "mason.providers.registry-api",
    },
  },
}
