-- Liste déclarative des thèmes
local themes = {
	"deparr/tairiki.nvim",
	"vague-theme/vague.nvim",
	"bluz71/vim-moonfly-colors",
	"rebelot/kanagawa.nvim",
	"folke/tokyonight.nvim",
	"catppuccin/nvim",
	"EdenEast/nightfox.nvim",
	"navarasu/onedark.nvim",
	"AlexvZyl/nordic.nvim",
	"nyoom-engineering/oxocarbon.nvim",
	"rose-pine/neovim",
	"elvessousa/sobrio",
	"nyoom-engineering/nyoom.nvim",
	"olimorris/onedarkpro.nvim",
	"oxfist/night-owl.nvim",
	"folke/styler.nvim",
	"yorumicolors/yorumi.nvim",
	"ribru17/bamboo.nvim",
	"kartikp10/noctis.nvim",
	"uhs-robert/oasis.nvim",
	{ "HoNamDuong/hybrid.nvim", colorscheme = "hybrid", default = true },
}

-- Transformation en specs Lazy.nvim
return vim.tbl_map(function(theme)
	-- Cas spécial : thème avec config (colorscheme auto-activé)
	if type(theme) == "table" and theme.default then
		return {
			theme[1],
			config = function()
				vim.cmd("colorscheme " .. theme.colorscheme)
			end,
		}
	end

	-- Cas standard : simple string
	return { theme, { "rktjmp/lush.nvim" } }
end, themes)
