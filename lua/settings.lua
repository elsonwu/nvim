vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.softtabstop = 2
vim.opt.expandtab = true
vim.opt.wrap = true
vim.opt.number = true
vim.opt.incsearch = true
vim.opt.showmatch = true
vim.opt.hls = true
vim.opt.swapfile = false
vim.opt.smartcase = true
vim.opt.history = 1000
vim.opt.showcmd = true
vim.opt.cursorline = true
vim.opt.signcolumn = "yes"
vim.opt.clipboard = "unnamedplus"
-- vim.opt.clipboard = vim.opt.clipboard + 'unnamedplus'
vim.opt.termguicolors = true
vim.opt.updatetime = 300

-- disable netrw at the very start of your init.lua (strongly advised)
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

local function get_node_path()
    -- Attempt to find the Node.js binary in the system's PATH
    local handle = io.popen("which node")
    if handle == nil then
        vim.notify("Failed to run which command. Please ensure it is installed and in your PATH.", vim.log.levels.ERROR)
        return nil
    end

    local result = handle:read("*a")
    handle:close()

    -- Trim any whitespace from the result
    local node_path = result:gsub("%s+", "")

    -- If the path is empty, fall back to a default or error out
    if node_path == "" then
        vim.notify("Node.js not found in PATH. Please install Node.js or set the path manually.", vim.log.levels.ERROR)
        return nil
    end

    return node_path
end

-- Copilet
vim.g.copilot_node_command = get_node_path()
vim.g.copilot_no_tab_map = true

-- better diagnostic sign
local signs = { Error = "🚨", Warn = "⚠️ ", Hint = "💡", Info = "⚡" }
for type, icon in pairs(signs) do
	local hl = "DiagnosticSign" .. type
	vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end

pcall(vim.cmd, "colorscheme dracula")
