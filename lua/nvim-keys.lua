local keys = {}

vim.g.mapleader = ","

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

	vim.keymap.set("n", "<S-Up>", "<CMD>resize +2<CR>", { desc = "Increase window height", silent = true })
	vim.keymap.set("n", "<S-Down>", "<CMD>resize -2<CR>", { desc = "Decrease window height", silent = true })
	vim.keymap.set("n", "<S-Left>", "<CMD>vertical resize -2<CR>", { desc = "Decrease window width", silent = true })
	vim.keymap.set("n", "<S-Right>", "<CMD>vertical resize +2<CR>", { desc = "Increase window width", silent = true })

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
end

return keys
