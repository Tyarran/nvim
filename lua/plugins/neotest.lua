return {
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
}
