return {
	{
		"mason-org/mason.nvim",
		opts = {},
	},
	{
		"nvim-treesitter/nvim-treesitter",
		dependencies = { "nvim-lua/plenary.nvim" },
		lazy = false,
		build = ":TSUpdate",
	},
	{
		"nvim-treesitter/nvim-treesitter-context",
	},
	{
		"nvim-treesitter/nvim-treesitter-textobjects",
	},
	{
		"stevearc/conform.nvim",
		opts = {},
		config = function()
			vim.keymap.set("n", "<leader>cf", function()
				require("conform").format()
			end, { desc = "Format buffer", silent = true })
		end,
	},
	{
		"mfussenegger/nvim-lint",
	},
	{
		"noirbizarre/ensure.nvim",
		dependencies = {
			"mason-org/mason.nvim", -- Required for tool installation
			-- Optional integrations:
			"nvim-treesitter/nvim-treesitter",
			"stevearc/conform.nvim",
			"mfussenegger/nvim-lint",
		},
		opts = {
			-- LSP servers
			lsp = {
				enable = { "lua_ls", "jsonls", "copilot-language-server" },
			},
			-- Formatters (by filetype)
			formatters = {
				lua = { "stylua" },
				python = { "ruff_format", "ruff_organize_imports" },
				javascript = { "prettier" },
				json = { "jq" },
			},
			-- Linters (by filetype)
			linters = {
				python = "ruff",
				javascript = "eslint",
			},
			parsers = { auto = true },
			packages = { "codespell" },
		},
	},
	{
		"folke/lazydev.nvim",
		ft = "lua", -- only load on lua files
		opts = {
			library = {
				-- See the configuration section for more details
				-- Load luvit types when the `vim.uv` word is found
				{ path = "luvit-meta/library", words = { "vim%.uv" } },
			},
		},
	},

	-- Rainbow Delimiters
	{
		"hiphish/rainbow-delimiters.nvim",
		config = function()
			-- This module contains a number of default definitions
			local rainbow_delimiters = require("rainbow-delimiters")

			---@type rainbow_delimiters.config
			vim.g.rainbow_delimiters = {
				strategy = {
					[""] = rainbow_delimiters.strategy["global"],
					vim = rainbow_delimiters.strategy["local"],
				},
				query = {
					[""] = "rainbow-delimiters",
					lua = "rainbow-blocks",
				},
				priority = {
					[""] = 110,
					lua = 210,
				},
				highlight = {
					"RainbowDelimiterRed",
					"RainbowDelimiterYellow",
					"RainbowDelimiterBlue",
					"RainbowDelimiterOrange",
					"RainbowDelimiterGreen",
					"RainbowDelimiterViolet",
					"RainbowDelimiterCyan",
				},
			}
		end,
	},
}
