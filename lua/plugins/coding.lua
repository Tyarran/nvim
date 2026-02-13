return {
	-- Blink (Completion)
	{
		"saghen/blink.cmp",
		-- optional: provides snippets for the snippet source
		dependencies = { { "rafamadriz/friendly-snippets" }, { "fang2hou/blink-copilot" } },
		-- opts = {
		--   max_completions = 1,  -- Global default for max completions
		--   max_attempts = 2,     -- Global default for max attempts
		--   -- `kind` is not set, so the default value is "Copilot"
		-- }
		-- ]

		-- use a release tag to download pre-built binaries
		version = "*",
		-- AND/OR build from source, requires nightly: https://rust-lang.github.io/rustup/concepts/channels.html#working-with-nightly-rust
		-- build = 'cargo build --release',
		-- If you use nix, you can build from source using latest nightly rust with:
		-- build = 'nix run .#build-plugin',

		---@module 'blink.cmp'
		---@type blink.cmp.Config
		opts = {
			-- 'default' for mappings similar to built-in completion
			-- 'super-tab' for mappings similar to vscode (tab to accept, arrow keys to navigate)
			-- 'enter' for mappings similar to 'super-tab' but with 'enter' to accept
			-- See the full "keymap" documentation for information on defining your own keymap.
			keymap = { preset = "super-tab" },

			appearance = {
				-- Sets the fallback highlight groups to nvim-cmp's highlight groups
				-- Useful for when your theme doesn't support blink.cmp
				-- Will be removed in a future release
				use_nvim_cmp_as_default = true,
				-- Set to 'mono' for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
				-- Adjusts spacing to ensure icons are aligned
				nerd_font_variant = "mono",
			},

			-- Default list of enabled providers defined so that you can extend it
			-- elsewhere in your config, without redefining it, due to `opts_extend`
			sources = {
				default = { "lsp", "path", "snippets", "buffer", "copilot" },
				-- default = { 'lsp', 'path', 'buffer', 'copilot' },
				providers = {
					copilot = {
						name = "copilot",
						module = "blink-copilot",
						score_offset = 100,
						async = true,
						opts = {
							-- Local options override global ones
							-- Final settings: max_completions = 3, max_attempts = 2, kind = "Copilot"
							max_completions = 3, -- Override global max_completions
						},
					},
				},
			},
			completion = {
				documentation = {
					auto_show = true,
					auto_show_delay_ms = 500,
				},

				ghost_text = { enabled = false },
			},
			signature = { enabled = true },
		},
		opts_extend = { "sources.default" },
	},

	-- Autopairs
	{
		"windwp/nvim-autopairs",
		event = "InsertEnter",
		config = true,
		-- use opts = {} for passing setup options
		-- this is equivalent to setup({}) function
	},

	-- Surround
	{
		"kylechui/nvim-surround",
		config = function()
			require("nvim-surround").setup({
				current_ligne_blame = true,
			})
		end,
		event = "insertEnter",
	},

	-- Comments
	{
		"terrortylor/nvim-comment",
		config = function()
			require("nvim_comment").setup()
		end,
		event = "BufRead",
	},

	-- Jinja
	{
		"HiPhish/jinja.vim",
		dependency = { "you-n-g/jinja-engine.nvim" },
	},

	-- Venv Selector (Python)
	{
		"linux-cultist/venv-selector.nvim",
		dependencies = {
			"neovim/nvim-lspconfig",
			-- { "nvim-telescope/telescope.nvim", branch = "0.1.x", dependencies = { "nvim-lua/plenary.nvim" } }, -- optional: you can also use fzf-lua, snacks, mini-pick instead.
		},
		ft = "python", -- Load when opening Python files
		keys = {
			{ ",v", "<cmd>VenvSelect<cr>" }, -- Open picker on keymap
		},
		opts = { -- this can be an empty lua table - just showing below for clarity.
			search = {}, -- if you add your own searches, they go here.
			options = {}, -- if you add plugin options, they go here.
		},
	},
}
