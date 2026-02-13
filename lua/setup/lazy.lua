local lazy = {}

function lazy.init()
	vim.notify(vim.fn.stdpath("data"))
	local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

	if not vim.loop.fs_stat(lazypath) then
		vim.fn.system({
			"git",
			"clone",
			"--filter=blob:none",
			"https://github.com/folke/lazy.nvim.git",
			"--branch=stable", -- latest stable release
			lazypath,
		})
	end

	vim.opt.rtp:prepend(lazypath)

	require("lazy").setup({
		spec = {
			{ import = "plugins" },
			{ import = "plugins/languages" },
		},
		local_spec = true,
		checker = { enabled = true },
	})
end

return lazy
