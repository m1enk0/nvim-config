return {
    'akinsho/toggleterm.nvim',
    version = "*",
    config = true,
    keys = {
	{"<A-y>", ":ToggleTerm<cr>"},
    },
    config = function()
	vim.cmd("let &shell = has('win32') ? 'powershell' : 'pwsh'")
	vim.cmd("let &shellcmdflag = '-NoLogo -NoProfile -ExecutionPolicy RemoteSigned -Command [Console]::InputEncoding=[Console]::OutputEncoding=[System.Text.Encoding]::UTF8;'")
	vim.cmd("let &shellredir = '-RedirectStandardOutput %s -NoNewWindow -Wait'")
	vim.cmd("let &shellpipe = '2>&1 | Out-File -Encoding UTF8 %s; exit $LastExitCode'")
	vim.cmd("set shellquote=")
	vim.cmd("set shellxquote=")

	require('toggleterm').setup { 
	    size = 20,
	    direction = 'float',
	    start_in_insert = true,
	    persist_mode = false,
	}
    end
}
