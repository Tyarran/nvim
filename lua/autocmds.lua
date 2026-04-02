local autocmds = {}

local function augroup(name)
	return vim.api.nvim_create_augroup("custom_au_" .. name, { clear = true })
end

function autocmds.init()
	-- Enable treesitter highlighting for all filetypes with an available parser
	vim.api.nvim_create_autocmd("FileType", {
		group = augroup("treesitter_highlight"),
		callback = function(args)
			pcall(vim.treesitter.start, args.buf)
		end,
	})
end

return autocmds
