return {
    'akinsho/toggleterm.nvim',
    version = "*",
    keys = {
        { "<A-y>", ":ToggleTerm<cr>" },
    },
    config = function()
        vim.cmd([[
            let &shell = 'powershell'
            let &shellcmdflag = '-NoLogo -NoProfile -ExecutionPolicy RemoteSigned -Command [Console]::InputEncoding=[Console]::OutputEncoding=[System.Text.Encoding]::UTF8;'
            let &shellredir = '-RedirectStandardOutput %s -NoNewWindow -Wait'
            let &shellpipe = '2>&1 | Out-File -Encoding UTF8 %s; exit $LastExitCode'
            set shellquote= shellxquote=
        ]])

        require('toggleterm').setup {
            size = 20,
            direction = 'horizontal',
            start_in_insert = true,
            persist_mode = false,
        }
    end
}
