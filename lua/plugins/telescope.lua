return {
   'nvim-telescope/telescope.nvim', tag = '0.1.5',
   dependencies = { 'nvim-lua/plenary.nvim' },
   opts = {
      pickers = {
	 find_files = {
	    theme = "dropdown"
	 },
	 command_history = {
	    theme = "dropdown"
	 },
	 live_grep = {
	    theme = "dropdown"
	 },
	 buffers = {
	    theme = "ivy"
	 },
	 help_tags = {
	    theme = "dropdown"
	 },
	 oldfiles = {
	    theme = "dropdown"
	 },
      },
      path_display = { "smart" },
   }
}
