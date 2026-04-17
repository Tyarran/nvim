return {
	-- Jujutsu conflict resolver
	{
		"rafikdraoui/jj-diffconflicts",
	},

	-- Jujutsu pickers (Snacks)
	{
		"folke/snacks.nvim",
		opts = function(_, opts)
			opts.picker = opts.picker or {}
			opts.picker.sources = opts.picker.sources or {}

			-- Finder jj log : master..@ par défaut, toggle pour tout afficher
			opts.picker.sources.jj_log = {
				title = "JJ Log (master..@)",
				finder = function(_opts, _ctx)
					local template = 'change_id.short(8) ++ "\\t" ++ author.timestamp().format("%Y-%m-%d") ++ "\\t" ++ author.email() ++ "\\t" ++ description.first_line() ++ "\\n"'
					local revset_arg = _opts.show_all and "" or ("-r " .. vim.fn.shellescape("present(master)..@"))
					local output = vim.fn.systemlist(
						"jj log --no-graph "
							.. revset_arg
							.. " --template "
							.. vim.fn.shellescape(template)
							.. " 2>/dev/null"
					)
					local items = {}
					for _, line in ipairs(output) do
						if line ~= "" then
							local id, date, author, msg = line:match("^([^\t]+)\t([^\t]+)\t([^\t]+)\t(.*)$")
							if id then
								table.insert(items, {
									text = id .. " " .. msg,
									commit = id,
									date = date,
									author = author,
									msg = msg,
								})
							end
						end
					end
					return items
				end,
				format = "git_log",
				preview = function(ctx)
					Snacks.picker.preview.cmd(
						{ "jj", "show", "--color", "always", ctx.item.commit },
						ctx,
						{ env = { PAGER = "cat" } }
					)
				end,
				confirm = function(picker, item)
					picker:close()
					local result = vim.fn.system("jj edit " .. vim.fn.shellescape(item.commit) .. " 2>&1")
					if vim.v.shell_error ~= 0 then
						vim.notify("jj edit failed: " .. result, vim.log.levels.ERROR)
					else
						vim.notify("Editing: " .. item.commit .. " " .. item.msg, vim.log.levels.INFO)
					end
				end,
				sort = { fields = { "score:desc", "idx" } },
				actions = {
					jj_abandon = function(picker, item)
						vim.ui.select({ "Oui, abandonner", "Non, annuler" }, {
							prompt = "Abandonner " .. item.commit .. " « " .. item.msg .. " » ?",
						}, function(choice)
							if choice ~= "Oui, abandonner" then
								return
							end
							picker:close()
							local result = vim.fn.system("jj abandon " .. vim.fn.shellescape(item.commit) .. " 2>&1")
							if vim.v.shell_error ~= 0 then
								vim.notify("jj abandon failed: " .. result, vim.log.levels.ERROR)
							else
								vim.notify("Abandoned: " .. item.commit .. " " .. item.msg, vim.log.levels.INFO)
							end
						end)
					end,
					jj_toggle_all = function(picker)
						picker.opts.show_all = not picker.opts.show_all
						picker.title = picker.opts.show_all
							and "JJ Log (all)"
							or "JJ Log (master..@)"
						picker:refresh()
					end,
				},
				win = {
					input = {
						keys = {
							["<c-a>"] = { "jj_toggle_all", mode = { "n", "i" }, desc = "Toggle all commits" },
							["<c-x>"] = { "jj_abandon", mode = { "n", "i" }, desc = "Abandon commit" },
						},
					},
				},
			}

			-- Finder jj mine : mes commits non mergés dans main/master
			opts.picker.sources.jj_mine = {
				title = "JJ My Commits",
				finder = function(_opts, _ctx)
					local revset = "mine() ~ (::present(main) | ::present(master))"
					local template = 'change_id.short(8) ++ "\\t" ++ author.timestamp().format("%Y-%m-%d") ++ "\\t" ++ author.email() ++ "\\t" ++ description.first_line() ++ "\\n"'
					local output = vim.fn.systemlist(
						"jj log --no-graph -r "
							.. vim.fn.shellescape(revset)
							.. " --template "
							.. vim.fn.shellescape(template)
							.. " 2>/dev/null"
					)
					local items = {}
					for _, line in ipairs(output) do
						if line ~= "" then
							local id, date, author, msg = line:match("^([^\t]+)\t([^\t]+)\t([^\t]+)\t(.*)$")
							if id then
								table.insert(items, {
									text = id .. " " .. msg,
									commit = id,
									date = date,
									author = author,
									msg = msg,
								})
							end
						end
					end
					return items
				end,
				format = "git_log",
				preview = function(ctx)
					Snacks.picker.preview.cmd(
						{ "jj", "show", "--color", "always", ctx.item.commit },
						ctx,
						{ env = { PAGER = "cat" } }
					)
				end,
				confirm = function(picker, item)
					picker:close()
					local result = vim.fn.system("jj edit " .. vim.fn.shellescape(item.commit) .. " 2>&1")
					if vim.v.shell_error ~= 0 then
						vim.notify("jj edit failed: " .. result, vim.log.levels.ERROR)
					else
						vim.notify("Editing: " .. item.commit .. " " .. item.msg, vim.log.levels.INFO)
					end
				end,
				sort = { fields = { "score:desc", "idx" } },
			}

			-- Finder jj op log : historique des opérations
			opts.picker.sources.jj_op_log = {
				title = "JJ Operations",
				finder = function(_opts, _ctx)
					local template = 'id.short(8) ++ "\\t" ++ time.start().format("%Y-%m-%d %H:%M") ++ "\\t" ++ description.first_line() ++ "\\n"'
					local output = vim.fn.systemlist(
						"jj op log --no-graph --template " .. vim.fn.shellescape(template) .. " 2>/dev/null"
					)
					local items = {}
					for _, line in ipairs(output) do
						if line ~= "" then
							local id, date, desc = line:match("^([^\t]+)\t([^\t]+)\t(.*)$")
							if id then
								table.insert(items, {
									text = id .. " " .. desc,
									commit = id,
									date = date,
									msg = desc,
								})
							end
						end
					end
					return items
				end,
				format = "git_log",
				preview = function(ctx)
					Snacks.picker.preview.cmd(
						{ "jj", "op", "show", "--color", "always", ctx.item.commit },
						ctx,
						{ env = { PAGER = "cat" } }
					)
				end,
				confirm = function(picker, item)
					vim.ui.select({ "Oui, annuler", "Non, garder" }, {
						prompt = "Undo « " .. item.msg .. " » ?",
					}, function(choice)
						if choice ~= "Oui, annuler" then
							return
						end
						picker:close()
						local result = vim.fn.system("jj op undo " .. vim.fn.shellescape(item.commit) .. " 2>&1")
						if vim.v.shell_error ~= 0 then
							vim.notify("jj op undo failed: " .. result, vim.log.levels.ERROR)
						else
							vim.notify("Undone: " .. item.msg, vim.log.levels.INFO)
						end
					end)
				end,
				sort = { fields = { "score:desc", "idx" } },
			}

			-- Finder jj diff avec toggle master (comme jj_log)
			opts.picker.sources.jj_diff = {
				title = "JJ Diff",
				finder = function(_opts, ctx)
					local cwd = vim.fn.systemlist("jj root 2>/dev/null")[1] or vim.fn.getcwd()
					
					-- Args selon le mode : diff normal ou depuis master
					local args = _opts.show_master 
						and { "diff", "--from", "present(master)", "--to", "@", "--git" }
						or { "diff", "--git" }
					
					-- Exécuter la commande pour voir s'il y a des résultats
					local cmd = "jj " .. table.concat(args, " ")
					local output = vim.fn.systemlist(cmd .. " 2>/dev/null")
					
					-- Si pas de sortie, créer un placeholder
					if not output or #output == 0 or (output[1] and output[1] == "") then
						local mode_text = _opts.show_master and "(master..@)" or "(working copy)"
						return {
							{
								file = "",
								text = "No changes " .. mode_text .. " (Press Ctrl+T to toggle)",
								status = "info",
							}
						}
					end
					
					-- Sinon, utiliser le finder Diff normal
					local Diff = require("snacks.picker.source.diff")
					return Diff.diff(
						ctx:opts({
							cmd = "jj",
							args = args,
							env = { PAGER = "cat" },
							cwd = cwd,
						}),
						ctx
					)
				end,
				format = function(item, _picker) 
					if item.status == "info" then
						return {
							{ "  ", "SnacksPickerIcon" },
							{ item.text, "Comment" },
						}
					else
						-- Format standard pour les vrais diffs
						return require("snacks.picker.format").git_status(item, _picker)
					end
				end,
				preview = function(ctx)
					-- Si c'est un placeholder info, afficher un message
					if ctx.item.status == "info" then
						return "No changes to preview.\n\nPress Ctrl+T to toggle between:\n- Working copy diff\n- Master diff (present(master)..@)"
					end
					
					local cwd = vim.fn.systemlist("jj root 2>/dev/null")[1] or vim.fn.getcwd()
					local args = ctx.picker.opts.show_master
						and { "diff", "--from", "present(master)", "--to", "@", "--git", ctx.item.file }
						or { "diff", "--git", ctx.item.file }
					
					Snacks.picker.preview.cmd(
						{ "jj", unpack(args) },
						ctx,
						{ 
							env = { PAGER = "cat" },
							cwd = cwd 
						}
					)
				end,
				matcher = { sort_empty = true },
				sort = { fields = { "score:desc", "file", "idx" } },
				actions = {
					jj_toggle_master = function(picker)
						picker.opts.show_master = not picker.opts.show_master
						picker.title = picker.opts.show_master
							and "JJ Diff (master..@)"
							or "JJ Diff"
						picker:refresh()
					end,
				},
				win = {
					input = {
						keys = {
							["<c-t>"] = { "jj_toggle_master", mode = { "n", "i" }, desc = "Toggle master diff" },
						},
					},
				},
			}

			opts.picker.sources.jj_bookmarks = {
				title = "JJ Bookmarks (local)",
				finder = function(_opts, _ctx)
					local output = vim.fn.systemlist("jj bookmark list --all-remotes 2>/dev/null")
					if vim.v.shell_error ~= 0 then
						output = vim.fn.systemlist("jj bookmark list 2>/dev/null")
					end
					local show_remotes = _opts.show_remotes or false
					local items = {}
					for _, line in ipairs(output) do
						if line ~= "" and not line:match("^%s+[%-%+@]") then
							local raw_name = line:match("^%s*([^:]+):")
							if raw_name then
								local is_divergent = raw_name:find("%(conflicted%)") ~= nil
								local name = raw_name
									:gsub("%s*%(conflicted%)%s*$", "")
									:gsub("%s+$", "")
								local is_remote = name:find("@") ~= nil
								if not is_remote or show_remotes then
									table.insert(items, {
										text = name,
										name = name,
										is_remote = is_remote,
										is_divergent = is_divergent,
									})
								end
							end
						end
					end
					return items
				end,
				format = function(item, _picker)
					local icon = item.is_divergent and "  "
						or item.is_remote and "  "
						or "  "
					local hl = item.is_divergent and "DiagnosticWarn"
						or item.is_remote and "Comment"
						or "Normal"
					return {
						{ icon, "SnacksPickerIcon" },
						{ item.text, hl },
					}
				end,
				preview = function(ctx)
					local cmd = ctx.item.is_divergent
						and { "jj", "log", "-r", "all:" .. ctx.item.name, "--color", "always", "-p", "--no-graph" }
						or { "jj", "show", "--color", "always", ctx.item.name }
					Snacks.picker.preview.cmd(cmd, ctx, { env = { PAGER = "cat" } })
				end,
				confirm = function(picker, item)
					picker:close()
					local result = vim.fn.system("jj new " .. vim.fn.shellescape(item.name) .. " 2>&1")
					if vim.v.shell_error ~= 0 then
						vim.notify("jj new failed: " .. result, vim.log.levels.ERROR)
					else
						vim.notify("New commit from: " .. item.name, vim.log.levels.INFO)
					end
				end,
				actions = {
					jj_toggle_remotes = function(picker)
						picker.opts.show_remotes = not picker.opts.show_remotes
						picker.title = picker.opts.show_remotes
							and "JJ Bookmarks (all)"
							or "JJ Bookmarks (local)"
						picker:refresh()
					end,
				},
				win = {
					input = {
						keys = {
							["<c-r>"] = { "jj_toggle_remotes", mode = { "n", "i" }, desc = "Toggle remotes" },
						},
					},
				},
			}
		end,
		keys = {
			{
				"<leader>jl",
				function()
					Snacks.picker.pick("jj_log")
				end,
				desc = "JJ Log (master..@)",
			},
			{
				"<leader>jL",
				function()
					Snacks.picker.pick("jj_log", { show_all = true })
				end,
				desc = "JJ Log (all)",
			},
			{
				"<leader>jm",
				function()
					Snacks.picker.pick("jj_mine")
				end,
				desc = "JJ My Commits",
			},
			{
				"<leader>jo",
				function()
					Snacks.picker.pick("jj_op_log")
				end,
				desc = "JJ Operations",
			},
			{
				"<leader>jd",
				function()
					Snacks.picker.pick("jj_diff")
				end,
				desc = "JJ Diff (Ctrl+T to toggle master)",
			},
			{
				"<leader>jb",
				function()
					Snacks.picker.pick("jj_bookmarks")
				end,
				desc = "JJ Bookmarks",
			},
		},
	},
}
