return {
	{
		"tiagovla/scope.nvim",
		config = function()
			require("scope").setup({})
		end,
	},
	{
		"akinsho/bufferline.nvim",
		version = "*",
		dependencies = "nvim-tree/nvim-web-devicons",
		-- config = function()
		--   require("bufferline").setup({
		--
		-- })
		config = function()
			require("bufferline").setup({
				-- options = {
				--   mode = "tabs"
				-- }
			})
			vim.keymap.set("n", "<S-h>", "<cmd>BufferLineCyclePrev<cr>", { silent = false, noremap = true })
			vim.keymap.set("n", "<S-l>", "<cmd>BufferLineCycleNext<cr>", { silent = false, noremap = true })
		end,
	},
}
