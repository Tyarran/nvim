return {
	{
		"EvWilson/spelunk.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim", -- For window drawing utilities
			-- 'nvim-telescope/telescope.nvim', -- Optional: for fuzzy search capabilities
			"nvim-treesitter/nvim-treesitter", -- Optional: for showing grammar context
		},
		config = function()
			require("spelunk").setup({
				enable_persist = true,
				base_mappings = {
					delete = "<leader>md",
					add = "<leader>ma",
					toggle = "<leader>mm",
				},
			})
		end,
	},
}
