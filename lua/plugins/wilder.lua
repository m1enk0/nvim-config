return {
    'gelguy/wilder.nvim',
    config = function()
	local wilder = require('wilder')
	wilder.setup({ modes = {':'} })

	wilder.set_option('pipeline', wilder.cmdline_pipeline({
	    fuzzy = 1
	}))

	wilder.set_option('renderer', wilder.popupmenu_renderer({
	    highlighter = wilder.basic_highlighter()
	}))
    end,
}
