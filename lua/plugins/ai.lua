return {
	{
		"zbirenbaum/copilot.lua",
		dependencies = {
			"copilotlsp-nvim/copilot-lsp", -- (optional) for NES functionality
		},
	},
	-- Sidekick (AI)
	{
		"folke/sidekick.nvim",
		opts = {
			-- add any options here
			cli = {
        win = {
          -- layout = "float",
          float = {
            border = "rounded",
          },
        },
				mux = {
					backend = "zellij",
					enabled = true,
					-- create = "split",
				      -- create = "terminal"
				},
				split = {
					vertical = true, -- vertical or horizontal split
					size = 0.3, -- size of the split (0-1 for percentage)
				},
				nes = { enabled = true },
				tools = {
					pi = {
						cmd = { "sh", "-c", "printf '\\033[?1000h\\033[?1006h'; exec pi" },
					},
				},
				prompts = {
					refactor = "Please refactor {this} to be more maintainable",
					security = "Review {file} for security vulnerabilities",
					custom = function(ctx)
						return "Current file: " .. ctx.buf .. " at line " .. ctx.row
					end,
					-- review = "Fait moi la review complet de cette PR: ",
					review = "/review ",
				},
			},
		},
		-- stylua: ignore
		keys = {
			{
				"<tab>",
				function()
					-- if there is a next edit, jump to it, otherwise apply it if any
					if not require("sidekick").nes_jump_or_apply() then
						return "<Tab>" -- fallback to normal tab
					end
				end,
				expr = true,
				desc = "Goto/Apply Next Edit Suggestion",
			},
			{
				"<leader>aa",
				function()
					require("sidekick.cli").toggle()
				end,
				desc = "Sidekick Toggle CLI",
			},
			{
				"<leader>af",
				function()
					-- Bascule la fenêtre CLI existante entre float et split à droite
					require("sidekick.cli.state").with(function(state)
						local term = state.terminal
						if not term then
							return
						end
						if term:is_open() then
							term:hide()
						end
						term.opts.layout = term.opts.layout == "float" and "right" or "float"
						term:show()
						term:focus()
					end, { attach = true })
				end,
				desc = "Sidekick Toggle CLI Layout (float/split)",
			},
			{
				"<leader>as",
				function()
					require("sidekick.cli").select()
				end,
				-- Or to select only installed tools:
				-- require("sidekick.cli").select({ filter = { installed = true } })
				desc = "Select CLI",
			},
			{
				"<leader>at",
				function()
					require("sidekick.cli").send({ msg = "{this}" })
				end,
				mode = { "x", "n" },
				desc = "Send This",
			},
			{
				"<leader>av",
				function()
					require("sidekick.cli").send({ msg = "{selection}" })
				end,
				mode = { "x" },
				desc = "Send Visual Selection",
			},
			{
				"<leader>ap",
				function()
					require("sidekick.cli").prompt()
				end,
				mode = { "n", "x" },
				desc = "Sidekick Select Prompt",
			},
			{
				"<c-.>",
				function()
					require("sidekick.cli").focus()
				end,
				mode = { "n", "x", "i", "t" },
				desc = "Sidekick Switch Focus",
			},
			-- Example of a keybinding to open Claude directly
			{
				"<leader>ac",
				function()
					require("sidekick.cli").toggle({ name = "claude", focus = true })
				end,
				desc = "Sidekick Toggle Claude",
			},
		},
	},
	-- {
	-- 	"sudo-tee/opencode.nvim",
	-- 	config = function()
	-- 		require("opencode").setup({})
	-- 	end,
	-- 	dependencies = {
	-- 		{
	-- 			"MeanderingProgrammer/render-markdown.nvim",
	-- 			opts = {
	-- 				anti_conceal = { enabled = false },
	-- 				file_types = { "markdown", "opencode_output" },
	-- 			},
	-- 			ft = { "markdown", "Avante", "copilot-chat", "opencode_output" },
	-- 		},
	-- 		-- Optional, for file mentions and commands completion, pick only one
	-- 		"saghen/blink.cmp",
	-- 		-- 'hrsh7th/nvim-cmp',
	--
	-- 		-- Optional, for file mentions picker, pick only one
	-- 		"folke/snacks.nvim",
	-- 		-- 'nvim-telescope/telescope.nvim',
	-- 		-- 'ibhagwan/fzf-lua',
	-- 		-- 'nvim_mini/mini.nvim',
	-- 	},
	-- },
}
