return {
	-- Debug Adapter Protocol (DAP)
	{
		"mfussenegger/nvim-dap-python",
		lazy = true,
		config = function()
			local python = vim.fn.expand("~/.local/share/nvim/mason/packages/debugpy/venv/bin/python")
			require("dap-python").setup(python)
		end,
		-- Consider the mappings at
		-- https://github.com/mfussenegger/nvim-dap-python?tab=readme-ov-file#mappings
		dependencies = {
			"mfussenegger/nvim-dap",
		},
	},

	-- Neotest
	{
		"nvim-neotest/neotest",
		dependencies = {
			"nvim-neotest/nvim-nio",
			"nvim-lua/plenary.nvim",
			"antoinemadec/FixCursorHold.nvim",
			"nvim-treesitter/nvim-treesitter",
			"nvim-neotest/neotest-python",
		},
		config = function()
			neotest = require("neotest")
			neotest.setup({
				adapters = {
					require("neotest-python")({
						runner = "eb",
						args = { "test" },
					}),
				},
			})
			vim.keymap.set("n", "<leader>tr", function()
				neotest.run.run()
			end, { noremap = true, silent = true })
			vim.keymap.set("n", "<leader>to", function()
				neotest.output.open()
			end, { noremap = true, silent = true })
			vim.keymap.set("n", "<leader>top", function()
				neotest.output_panel.toggle()
			end, { noremap = true, silent = true })
			vim.keymap.set("n", "<leader>ts", function()
				neotest.summary.toggle()
			end, { noremap = true, silent = true })
		end,
	},
}
