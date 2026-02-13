return {
	"epwalsh/obsidian.nvim",
	config = function()
		require("obsidian").setup({
			dir = "~/Documents/rcommande",
			-- Optional, key mappings.
			mappings = {
				-- Overrides the 'gf' mapping to work on markdown/wiki links within your vault.
				["gr"] = {
					action = function()
						return require("obsidian").util.gf_passthrough()
					end,
					opts = { noremap = false, expr = true, buffer = true },
				},
			},

			-- Optional, if set to true, the specified mappings in the `mappings`
			-- table will overwrite existing ones. Otherwise a warning is printed
			-- and the mappings are not applied.
			-- overwrite_mappings = false,
			--
			new_notes_location = "Notes permanentes",
			-- Optional, completion.
			completion = {
				-- If using nvim-cmp, otherwise set to false
				-- nvim_cmp = true,
				-- Trigger completion at 2 chars
				min_chars = 2,
				-- Where to put new notes created from completion. Valid options are
				--  * "current_dir" - put new notes in same directory as the current buffer.
				--  * "notes_subdir" - put new notes in the default notes subdirectory.

				-- Whether to add the output of the node_id_func to new notes in autocompletion.
				-- E.g. "[[Foo" completes to "[[foo|Foo]]" assuming "foo" is the ID of the note.
				-- prepend_note_id = true
			},

			templates = {
				folder = "templates",
				-- date_format = "%Y-%m-%d-%a",
				-- time_format = "%H:%M",
			},

			daily_notes = {
				-- Optional, if you keep daily notes in a separate directory.
				folder = "Notes quotidiennes",
				-- Optional, if you want to change the date format for the ID of daily notes.
				date_format = "%Y-%m-%d",
				-- Optional, if you want to change the date format of the default alias of daily notes.
				alias_format = "%B %-d, %Y",
				-- Optional, default tags to add to each new daily note created.
				default_tags = { "daily-notes" },
				-- Optional, if you want to automatically insert a template from your template directory like 'daily.md'
				template = "Note quotidienne.md",
			},
		})
		vim.keymap.set("n", "<leader>os", ":ObsidianSearch<CR>", { noremap = true, silent = true })
		vim.keymap.set("n", "<leader>oqs", ":ObsidianQuickSwitch<CR>", { noremap = true, silent = true })
		vim.keymap.set("n", "<leader>on", ":ObsidianNew ", { noremap = true })
		vim.keymap.set("n", "<leader>otd", ":ObsidianToday<CR>", { noremap = true })
	end,
}
