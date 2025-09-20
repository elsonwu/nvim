-- Startup profiling utilities
local M = {}

-- Function to profile startup time
function M.profile_startup()
  local start_time = vim.loop.hrtime()
  
  vim.api.nvim_create_autocmd("VimEnter", {
    once = true,
    callback = function()
      local end_time = vim.loop.hrtime()
      local startup_time = (end_time - start_time) / 1e6 -- Convert to milliseconds
      print(string.format("Neovim startup time: %.2f ms", startup_time))
    end
  })
end

-- Function to check for slow plugins
function M.check_slow_plugins()
  vim.api.nvim_create_user_command("ProfilePlugins", function()
    require("lazy").profile()
  end, { desc = "Show plugin loading profile" })
end

-- Function to benchmark file opening
function M.benchmark_file_open()
  vim.api.nvim_create_user_command("BenchmarkOpen", function()
    local start = vim.loop.hrtime()
    vim.cmd("edit " .. vim.fn.expand("%"))
    local duration = (vim.loop.hrtime() - start) / 1e6
    print(string.format("File open time: %.2f ms", duration))
  end, { desc = "Benchmark file opening time" })
end

function M.setup()
  M.check_slow_plugins()
  M.benchmark_file_open()
end

return M
