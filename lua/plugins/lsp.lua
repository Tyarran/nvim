vim.api.nvim_create_autocmd("FileType", {
	desc = "Enable Treesitter",
	group = vim.api.nvim_create_augroup("enable_treesitter", {}),
	-- Don't filter by `pattern`, install and enable Treesitter parsers for all languages.
	callback = function()
		-- Enable Treesitter syntax highlighting.
		if pcall(vim.treesitter.start) then
			-- Use Treesitter indentation and folds.
			vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
			-- vim.wo.foldmethod = "expr"
			-- vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
		end
	end,
})
return {
	{
		"mason-org/mason.nvim",
		opts = {},
	},
	{
		"nvim-treesitter/nvim-treesitter",
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
				-- enable = { "lua_ls", "ty" },
			},
			-- Formatters (by filetype)
			formatters = {
				lua = { "stylua" },
				python = { "ruff_format", "ruff_organize_imports" },
				javascript = "prettier",
			},
			-- Linters (by filetype)
			linters = {
				python = "ruff",
				javascript = "eslint",
			},
			-- Tree-sitter parsers (array format for specific parsers)
			parsers = { auto = true },
			-- Additional Mason packages
			packages = { "codespell" },
		},
	},
}
