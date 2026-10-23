local opts = {}

function opts.init()
	vim.opt.ai = true
	vim.opt.background = "dark"
	vim.opt.cursorline = true
	vim.opt.hidden = true
	vim.opt.hlsearch = true
	vim.opt.ic = true
	vim.opt.inccommand = "nosplit"
	vim.opt.incsearch = true
	vim.opt.mouse = "a"
  vim.opt.mousescroll = "ver:6,hor:6"
	-- vim.opt.selectmode = "mouse" -- une selection a la souris demarre en mode Select (retour propre en Insert), pas en Visual
	vim.opt.number = true
	vim.opt.smartindent = true
	vim.opt.smartcase = true
	vim.opt.termguicolors = true
	vim.opt.relativenumber = false
	vim.opt.clipboard = "unnamedplus"
	vim.opt.syntax = "off"
	vim.opt.laststatus = 3
	vim.opt.runtimepath:append("/home/romain/.local/share/nvim/site")
	vim.opt.grepprg = "rg --vimgrep --smart-case --hidden"
	vim.opt.wrap = true
	vim.cmd.colorscheme("tairiki")

	vim.diagnostic.config({
		virtual_text = true, -- ou false pour désactiver
		signs = true, -- affiche les sign icons à gauche
		underline = true,
		update_in_insert = false,
		severity_sort = true,
	})

	-- Treesitter folding
	vim.opt.foldmethod = "expr"
	vim.opt.foldexpr = "v:lua.require('nvim-treesitter').foldexpr()"
	vim.opt.foldlevel = 99 -- Don't fold by default
end

return opts
