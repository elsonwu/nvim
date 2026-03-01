-- Replaced by copilot.lua (Lua-native, blink.cmp compatible)
return {
	enabled = false,
	"github/copilot.vim",
	event = "InsertEnter", -- Load only in insert mode
	config = function()
		-- Improve performance with these settings
		vim.g.copilot_no_tab_map = true
		vim.g.copilot_assume_mapped = true
		vim.g.copilot_tab_fallback = ""
		
		-- Limit suggestions to certain filetypes for better performance
		vim.g.copilot_filetypes = {
			["*"] = false,
			["javascript"] = true,
			["typescript"] = true,
			["lua"] = true,
			["rust"] = true,
			["python"] = true,
			["go"] = true,
		}
	end
}
