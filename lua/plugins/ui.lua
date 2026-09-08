return {
	-- Lualine (Statusline)
	{
		"nvim-lualine/lualine.nvim",
		config = function()
			require("lualine").setup({
				options = {
					icons_enabled = true,
					theme = "auto",
					component_separators = { left = "", right = "" },
					section_separators = { left = "", right = "" },
					disabled_filetypes = {
						statusline = {},
						winbar = {},
					},
					ignore_focus = {},
					always_divide_middle = true,
					globalstatus = true,
					refresh = {
						statusline = 1000,
						tabline = 1000,
						winbar = 1000,
					},
				},
				sections = {
					lualine_a = {
						"mode",
						{
							"macro",
							fmt = function()
								local reg = vim.fn.reg_recording()
								if reg ~= "" then
									return "Recording @" .. reg
								end
								return nil
							end,
							draw_empty = false,
						},
					},
					lualine_b = { "branch", "diff", "diagnostics" },
					lualine_c = {
						{
							"filename",
							path = 1, -- Affiche le chemin complet du fichier
						},
					},
					lualine_x = { "encoding", "fileformat", "filetype" },
					lualine_y = { "progress" },
					lualine_z = { "location" },
				},
				inactive_sections = {
					lualine_a = {},
					lualine_b = {},
					lualine_c = { "filename" },
					lualine_x = { "location" },
					lualine_y = {},
					lualine_z = {},
				},
				tabline = {},
				winbar = {},
				inactive_winbar = {},
				extensions = {},
			})

			-- code-2026 expose son thème lualine sous le nom "code-2026", alors que
			-- le colorscheme lui-même s'appelle "dark-2026" / "light-2026" :
			-- l'option theme = "auto" de lualine ne peut donc pas le détecter seule.
			vim.api.nvim_create_autocmd("ColorScheme", {
				desc = "Basculer lualine sur le thème code-2026 quand dark-2026/light-2026 est actif",
				group = vim.api.nvim_create_augroup("lualine_code_2026", {}),
				pattern = { "dark-2026", "light-2026" },
				callback = function()
					require("lualine").setup({ options = { theme = "code-2026" } })
				end,
			})
		end,
	},

	-- Noice (UI Enhancements)
	{
		"folke/noice.nvim",
		event = "VeryLazy",
		priority = 1000,
		opts = {
			-- add any options here
		},
		dependencies = {
			-- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
			"MunifTanjim/nui.nvim",
		},

		config = function()
			require("noice").setup({
				lsp = {
					-- override markdown rendering so that **cmp** and other plugins use **Treesitter**
					override = {
						-- ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
						-- ["vim.lsp.util.stylize_markdown"] = true,
						["cmp.entry.get_documentation"] = true, -- requires hrsh7th/nvim-cmp
					},
				},
				-- you can enable a preset for easier configuration
				presets = {
					bottom_search = false, -- use a classic bottom cmdline for search
					command_palette = true, -- position the cmdline and popupmenu together
					long_message_to_split = true, -- long messages will be sent to a split
					inc_rename = false, -- enables an input dialog for inc-rename.nvim
					lsp_doc_border = false, -- add a border to hover docs and signature help
				},
				-- Disable notifications in Noice (using Snacks instead)
				notify = {
					enabled = false,
				},
			})
		end,
	},

	-- Dropbar (Breadcrumbs/Winbar)
	{
		"Bekaboo/dropbar.nvim",
		-- optional, but required for fuzzy finder support
		dependencies = {
			"nvim-telescope/telescope-fzf-native.nvim",
			build = "make",
		},
		config = function()
			local dropbar_api = require("dropbar.api")
			vim.keymap.set("n", "<Leader>;", dropbar_api.pick, { desc = "Pick symbols in winbar" })
			vim.keymap.set("n", "[;", dropbar_api.goto_context_start, { desc = "Go to start of current context" })
			vim.keymap.set("n", "];", dropbar_api.select_next_context, { desc = "Select next context" })
		end,
	},


	-- Scope (Tab-scoped buffers)
	{
		"tiagovla/scope.nvim",
		config = function()
			require("scope").setup({})
		end,
	},

	-- Bufferline
	{
		"akinsho/bufferline.nvim",
		version = "*",
		dependencies = "nvim-tree/nvim-web-devicons",
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

	-- Quicker (Quickfix improvements)
	{
		"stevearc/quicker.nvim",
		opts = {},
	},

	-- Which-Key
	{
		"folke/which-key.nvim",
		config = function()
			vim.o.timeout = true
			vim.o.timeoutlen = 300
			require("which-key").setup({
				-- your configuration comes here
				-- or leave it empty to use the default settings
				-- refer to the configuration section below
			})
		end,
	},

	-- Scrollbar (with diagnostics, cursor and gitsigns marks)
	{
		"petertriho/nvim-scrollbar",
		event = "VeryLazy",
		dependencies = { "lewis6991/gitsigns.nvim" },
		config = function()
			local colors = require("tokyonight.colors").setup()

			require("scrollbar").setup({
				handle = { color = colors.bg_highlight },
				marks = {
					Search = { color = colors.orange },
					Error = { color = colors.error },
					Warn = { color = colors.warning },
					Info = { color = colors.info },
					Hint = { color = colors.hint },
					Misc = { color = colors.purple },
				},
				handlers = { gitsigns = true },
			})

			require("scrollbar.handlers.gitsigns").setup()
		end,
	},

	-- Trouble (Diagnostics list)
	{
		"folke/trouble.nvim",
		cmd = { "TroubleToggle", "Trouble" },
		config = function()
			require("trouble").setup({})
			vim.keymap.set("n", "<Leader>xx", "<cmd>TroubleToggle<cr>", { silent = true, noremap = true })
		end,
	},
}
