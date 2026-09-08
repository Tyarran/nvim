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
		opts = {
			max_lines = 1,
		},
	},
	{
		"nvim-treesitter/nvim-treesitter-textobjects",
		dependencies = "nvim-treesitter/nvim-treesitter",
		init = function()
			vim.g.no_plugin_maps = true
		end,
		config = function()
			require("nvim-treesitter-textobjects").setup({
				select = {
					lookahead = true,
					include_surrounding_whitespace = false,
				},
				move = {
					set_jumps = true,
				},
			})

			-- Select keymaps
			vim.keymap.set({ "x", "o" }, "af", function()
				require("nvim-treesitter-textobjects.select").select_textobject("@function.outer", "textobjects")
			end, { desc = "Select around function" })

			vim.keymap.set({ "x", "o" }, "if", function()
				require("nvim-treesitter-textobjects.select").select_textobject("@function.inner", "textobjects")
			end, { desc = "Select inside function" })

			vim.keymap.set({ "x", "o" }, "ac", function()
				require("nvim-treesitter-textobjects.select").select_textobject("@class.outer", "textobjects")
			end, { desc = "Select around class" })

			vim.keymap.set({ "x", "o" }, "ic", function()
				require("nvim-treesitter-textobjects.select").select_textobject("@class.inner", "textobjects")
			end, { desc = "Select inside class" })

			-- Move keymaps
			vim.keymap.set({ "n", "x", "o" }, "]f", function()
				require("nvim-treesitter-textobjects.move").goto_next_start("@function.outer", "textobjects")
			end, { desc = "Goto next function start" })

			vim.keymap.set({ "n", "x", "o" }, "[f", function()
				require("nvim-treesitter-textobjects.move").goto_previous_start("@function.outer", "textobjects")
			end, { desc = "Goto previous function start" })

			vim.keymap.set({ "n", "x", "o" }, "]c", function()
				require("nvim-treesitter-textobjects.move").goto_next_start("@class.outer", "textobjects")
			end, { desc = "Goto next class start" })

			vim.keymap.set({ "n", "x", "o" }, "[c", function()
				require("nvim-treesitter-textobjects.move").goto_previous_start("@class.outer", "textobjects")
			end, { desc = "Goto previous class start" })
		end,
	},
  {
    "shushtain/incselect.nvim",
  },
	{
		"MeanderingProgrammer/treesitter-modules.nvim",
		config = function()
			require("treesitter-modules").setup({
				jump = { enabled = true },
				highlight = { enabled = true },
			})
		end,
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

	-- Treesitter Playground for debugging
	{
		"nvim-treesitter/playground",
		cmd = { "TSPlaygroundToggle" },
		dependencies = "nvim-treesitter/nvim-treesitter",
	},
}
