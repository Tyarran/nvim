return {
	{
		"deparr/tairiki.nvim",
	},
	{
		"vague-theme/vague.nvim",
		lazy = false,
		priority = 1000,
		config = function()
			require("vague").setup({})
		end,
	},
	{ "bluz71/vim-moonfly-colors", name = "moonfly", lazy = false, priority = 1000 },
	{
		"rebelot/kanagawa.nvim",
		lazy = false,
		priority = 1000,
		opts = {},
		-- config = function()
		-- 	vim.cmd("colorscheme kanagawa")
		-- end,
	},
	{
		"folke/tokyonight.nvim",
		lazy = false,
		priority = 1000,
		opts = {},
	},
	{
		"catppuccin/nvim",
		config = function()
			-- vim.cmd("colorscheme catppuccin-mocha")
		end,
	},
	{
		"EdenEast/nightfox.nvim",
		config = function()
			require("nightfox").setup({})
		end,
	},
	{
		"navarasu/onedark.nvim",
	},
	{
		"AlexvZyl/nordic.nvim",
	},
	{
		"nyoom-engineering/oxocarbon.nvim",
	},
	{
		"rose-pine/neovim",
		config = function()
			vim.cmd("colorscheme rose-pine-moon")
		end,
	},
	{
		"elvessousa/sobrio",
	},
	{
		"nyoom-engineering/nyoom.nvim",
	},
}
