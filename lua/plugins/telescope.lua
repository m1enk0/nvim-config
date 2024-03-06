return {
    'nvim-telescope/telescope.nvim', tag = '0.1.5',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
	require("telescope").setup {
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
		git_status = {
		    theme = "ivy"
		}
	    },
	    path_display = { "smart" },
	}
	vim.api.nvim_set_hl(0, "TelescopeNormal", { bg = "#262626" })
	vim.api.nvim_set_hl(0, "TelescopePreviewBorder", { fg = "#424242", bg = "#262626" })
	vim.api.nvim_set_hl(0, "TelescopePromptBorder", { fg="#424242", bg = "#262626" })
	vim.api.nvim_set_hl(0, "TelescopeResultsBorder", { fg="#424242", bg = "#262626" })
	vim.api.nvim_set_hl(0, "TelescopePreviewTitle", { fg="#A1A1A1", bg = "#262626" })
	vim.api.nvim_set_hl(0, "TelescopePromptTitle", { fg="#A1A1A1", bg = "#262626" })
	vim.api.nvim_set_hl(0, "TelescopeResultsTitle", { fg="#A1A1A1", bg = "#262626" })
    end
}
