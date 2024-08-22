return {
	"williamboman/mason.nvim",
	-- event = "VeryLazy",
	build = ":MasonUpdate",
	opts = {
		providers = {
			"mason.providers.client",
			"mason.providers.registry-api",
		},
	},
}
