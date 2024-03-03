return {
   "nvim-treesitter/nvim-treesitter",
   build = ":TSUpdate",
   config = function()
      local configs = require("nvim-treesitter.configs")
      configs.setup({ 
	 highlight = {
	    enable = true,
	    additional_vim_regex_highlighting = false,
	 },
	 context_commentstring = {
	    enable = true,
	    enable_autocmd = false,
	 },
	 autotag = { enable = true },
	 incremental_selection = { enable = true },
	 indent = { enable = true },
	 auto_install = true,
      })
   end
}
