return {
	"kylechui/nvim-surround",
	config = function()
		require("nvim-surround").setup({
			current_ligne_blame = true,
		})
	end,
	event = "insertEnter",
}
