local keys = {}

vim.g.mapleader = ","

--- Find (or create) a window suitable for opening a file, skipping terminal
--- and floating windows. Used so that `gx` triggered from inside a terminal
--- buffer opens the target file in a proper editor window instead of
--- replacing the terminal.
local function find_or_create_editor_window()
	local function is_candidate(win)
		local ok_buf, buf = pcall(vim.api.nvim_win_get_buf, win)
		if not ok_buf then
			return false
		end
		if vim.bo[buf].buftype == "terminal" then
			return false
		end
		local ok_cfg, cfg = pcall(vim.api.nvim_win_get_config, win)
		if ok_cfg and cfg.relative ~= "" then
			return false
		end
		return true
	end

	-- 1. alternate window in the current tab
	local alt_win = vim.fn.win_getid(vim.fn.winnr("#"))
	if alt_win ~= 0 and is_candidate(alt_win) then
		return alt_win
	end

	-- 2. any other window in the current tab
	for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
		if is_candidate(win) then
			return win
		end
	end

	-- 3. any window in another tab
	local current_tab = vim.api.nvim_get_current_tabpage()
	for _, tab in ipairs(vim.api.nvim_list_tabpages()) do
		if tab ~= current_tab then
			for _, win in ipairs(vim.api.nvim_tabpage_list_wins(tab)) do
				if is_candidate(win) then
					vim.api.nvim_set_current_tabpage(tab)
					return win
				end
			end
		end
	end

	-- 4. last resort: create a vertical split in the current tab
	vim.cmd("vsplit")
	return vim.api.nvim_get_current_win()
end

--- Resolve a "path:line" or "path:line1-line2" reference under the cursor
--- and open it as a buffer (visually selecting the range if present).
--- Falls back to Neovim's native `gx` behaviour (vim.ui.open on <cfile>)
--- for URLs and anything that isn't a known file.
--- If triggered from a terminal buffer, the file is opened in a separate
--- editor window instead of replacing the terminal.
local function smart_gx()
	local line = vim.api.nvim_get_current_line()
	local cursor_col = vim.api.nvim_win_get_cursor(0)[2] + 1 -- 1-indexed

	local match_text
	local search_from = 1
	while true do
		local s, e = line:find("[%w%._%-/]+:%d+%-?%d*", search_from)
		if not s then
			break
		end
		if cursor_col >= s and cursor_col <= e then
			match_text = line:sub(s, e)
			break
		end
		search_from = e + 1
	end

	if match_text then
		local path, line1_str, line2_str = match_text:match("^(.-):(%d+)%-?(%d*)$")
		if path and vim.uv.fs_stat(path) then
			if vim.bo.buftype == "terminal" then
				vim.api.nvim_set_current_win(find_or_create_editor_window())
			end
			vim.cmd.edit(vim.fn.fnameescape(path))

			local last_line = vim.api.nvim_buf_line_count(0)
			local l1 = math.min(tonumber(line1_str), last_line)
			vim.api.nvim_win_set_cursor(0, { l1, 0 })

			local l2 = tonumber(line2_str)
			if l2 and l2 > l1 then
				l2 = math.min(l2, last_line)
				vim.cmd("normal! V")
				vim.api.nvim_win_set_cursor(0, { l2, 0 })
			end
			return
		end
	end

	-- Fallback: native gx behaviour (open URL/file with the system opener)
	local cfile = vim.fn.expand("<cfile>")
	if cfile ~= "" then
		vim.ui.open(cfile)
	end
end

function keys.init()
	vim.keymap.set("n", "<C-y>", ":set hlsearch! hlsearch?<CR>", { noremap = true, silent = true })
	vim.keymap.set("n", "<C-d>f", ":bd!<CR>", { noremap = true, silent = true })
	-- vim.keymap.set("t", "<C-n><C-n>", "<C-\\><C-n>", { noremap = true, silent = true })
	vim.keymap.set("n", "<C-w>n", ":split<CR>", { noremap = true, silent = true })
	vim.keymap.set("n", "<leader>q", "<cmd>q<cr>", { noremap = true, silent = true })

	-- tab
	vim.keymap.set("n", "<A-h>", ":tabprevious<cr>", { noremap = true, silent = true })
	vim.keymap.set("n", "<A-l>", ":tabnext<cr>", { noremap = true, silent = true })
	vim.keymap.set("n", "<leader>tn", ":tabnew<cr>", { noremap = true, silent = true })
	vim.keymap.set("n", "<leader>tc", ":tabclose<cr>", { noremap = true, silent = true })

	-- buffers
	vim.keymap.set("n", "<S-d>", ":BufferClose<CR>", { noremap = true, silent = true })

	-- Window navigation (normal and visual modes)
	vim.keymap.set({"n", "v"}, "<C-Up>", "<C-w>k", { desc = "Move to upper window", noremap = true, silent = true })
	vim.keymap.set({"n", "v"}, "<C-Down>", "<C-w>j", { desc = "Move to lower window", noremap = true, silent = true })
	vim.keymap.set({"n", "v"}, "<C-Left>", "<C-w>h", { desc = "Move to left window", noremap = true, silent = true })
	vim.keymap.set({"n", "v"}, "<C-Right>", "<C-w>l", { desc = "Move to right window", noremap = true, silent = true })

	-- Window resizing
	vim.keymap.set("n", "<S-Up>", "<CMD>resize +2<CR>", { desc = "Increase window height", silent = true })
	vim.keymap.set("n", "<S-Down>", "<CMD>resize -2<CR>", { desc = "Decrease window height", silent = true })
	vim.keymap.set("n", "<S-Left>", "<CMD>vertical resize -2<CR>", { desc = "Decrease window width", silent = true })
	vim.keymap.set("n", "<S-Right>", "<CMD>vertical resize +2<CR>", { desc = "Increase window width", silent = true })

	vim.keymap.set(
		"n",
		"<leader>jj",
		"<CMD>TermExec name=jj direction=float cmd='exec lazyjj'<CR>",
		{ noremap = true, silent = true, desc = "Open lazyjj in a floating terminal" }
	)

	-- Molette souris en Insert/Visual : scroll doux (une ligne) de la fenetre
	-- survolee par la souris, sans jamais changer de mode ni deplacer le
	-- curseur. Fonctionne bien ici car ce ne sont pas des buffers :terminal :
	-- pas de synchronisation continue du curseur sur un pty qui viendrait
	-- annuler le changement de topline.
	local function scroll_window_under_mouse(delta)
		local mouse = vim.fn.getmousepos()
		local winid = mouse.winid ~= 0 and mouse.winid or vim.api.nvim_get_current_win()
		vim.api.nvim_win_call(winid, function()
			local view = vim.fn.winsaveview()
			view.topline = math.max(1, view.topline + delta)
			vim.fn.winrestview(view)
		end)
	end

	-- vim.keymap.set({ "i", "v" }, "<ScrollWheelUp>", function()
	-- 	scroll_window_under_mouse(-1)
	-- end, { noremap = true, silent = true, desc = "Scroll up de la fenetre survolee sans changer de mode" })
	--
	-- vim.keymap.set({ "i", "v" }, "<ScrollWheelDown>", function()
	-- 	scroll_window_under_mouse(1)
	-- end, { noremap = true, silent = true, desc = "Scroll down de la fenetre survolee sans changer de mode" })

	-- Molette souris dans un buffer :terminal (mode Terminal-Job) : on ne peut
	-- pas scroller la vue Neovim (topline) tout en restant en mode Terminal,
	-- car Neovim y synchronise en continu le curseur sur la position reelle
	-- du curseur du pty (pour l'afficher en direct), ce qui annule tout
	-- deplacement manuel du curseur/topline au prochain redraw (cf. tests
	-- effectues : le topline revient systematiquement en bas, meme sur une
	-- sortie deja terminee et statique). On remappe donc l'evenement molette
	-- sur PageUp/PageDown : en mode Terminal-Job, Neovim forwarde nativement
	-- n'importe quelle touche au job (sauf <C-\>), donc PageUp/PageDown
	-- partent directement au processus enfant sans jamais changer de mode.
	-- La plupart des TUI (opencode, pi, less, htop...) gerent PageUp/PageDown
	-- pour leur propre scroll d'historique, de maniere fiable et
	-- independante du mouse-tracking.
	-- Limite connue : un shell nu (bash/zsh) sans pager ne fait rien de
	-- PageUp/PageDown ; pas de scroll local du buffer terminal possible dans
	-- ce cas (cf. justification ci-dessus).
	-- vim.keymap.set("t", "<ScrollWheelUp>", "<PageUp>", { noremap = true, silent = true, desc = "Forwarder le scroll up comme PageUp au job terminal" })
	-- vim.keymap.set("t", "<ScrollWheelDown>", "<PageDown>", { noremap = true, silent = true, desc = "Forwarder le scroll down comme PageDown au job terminal" })

	-- Remap Esc à <S-leader><S-leader>
	vim.api.nvim_set_keymap("i", "<leader><leader>", "<Esc>", { noremap = true, silent = true })
	vim.api.nvim_set_keymap("v", "<leader><leader>", "<Esc>", { noremap = true, silent = true })
	vim.api.nvim_set_keymap("c", "<leader><leader>", "<Esc>", { noremap = true, silent = true })
	vim.api.nvim_set_keymap("t", "<leader><leader>", "<Esc>", { noremap = true, silent = true })

	-- code_action
	vim.keymap.set(
		"n",
		"<leader>ca>",
		":lua vim.lsp.buf.code_action()<cr>",
		{ desc = "List code actions", silent = true }
	)

	--quickfix list
	vim.keymap.set("n", "<A-]>", ":cnext<CR>", { noremap = true, silent = true })
	vim.keymap.set("n", "<A-[>", ":cprevious<CR>", { noremap = true, silent = true })
	vim.keymap.set("n", "<leader>qq", ":copen<CR>", { noremap = true, silent = true })

	--lsp
	vim.keymap.set("n", "gi", function()
		vim.lsp.buf.incoming_calls()
	end, { noremap = true, silent = true })
	vim.keymap.set("n", "go", function()
		vim.lsp.buf.outgoing_calls()
	end, { noremap = true, silent = true })
	vim.keymap.set("n", "<leader>h", function()
		vim.lsp.buf.hover()
	end, { noremap = true, silent = true })
	vim.keymap.set("n", "<leader>ca", function()
		vim.lsp.buf.code_action()
	end, { noremap = true, silent = true })
	vim.keymap.set("n", "<leader>rn", function()
		vim.lsp.buf.rename()
	end, { noremap = true, silent = true })
	-- { "gi",              function() Snacks.picker.lsp_implementations() end,                     desc = "Goto Implementation" },

	-- terminal
	vim.keymap.set("t", "<ESC><ESC>", "<C-\\><C-n><leader>tt", { noremap = true, silent = true })
	vim.keymap.set("t", ",,", "<C-\\><C-n>", { noremap = true, silent = true })
	-- vim.keymap.set("t", ",,,", "<C-\\><C-n><leader>tt", { noremap = true, silent = true })

	-- Treesitter incremental selection via incselect.nvim
	vim.keymap.set("n", "<leader>v", function()
		require("incselect").init()
	end, { noremap = true, silent = true, desc = "Init incremental selection" })

	vim.keymap.set({ "n", "v" }, "<Up>", function()
		require("incselect").parent()
	end, { noremap = true, silent = true, desc = "Expand selection to parent" })

	vim.keymap.set({ "n", "v" }, "<Down>", function()
		require("incselect").child()
	end, { noremap = true, silent = true, desc = "Shrink selection to child" })

	-- gx: open file:line[-line] reference as a buffer, else fallback to native gx
	vim.keymap.set("n", "gx", smart_gx, { noremap = true, silent = true, desc = "Open file:line under cursor" })
end

return keys
