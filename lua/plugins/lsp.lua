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
				enable = { "lua_ls", "jsonls" },
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






}
