return {
	"williamboman/mason.nvim",
	event = "UIEnter",
	-- event = "VeryLazy",
	build = ":MasonUpdate",
	opts = {
		providers = {
			"mason.providers.client",
			"mason.providers.registry-api",
		},
	},
}
