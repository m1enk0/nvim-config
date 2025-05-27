return {
    'akinsho/toggleterm.nvim',
    keys = {
        { "<A-y>", "<cmd>ToggleTerm<cr>" },
    },
    cmd = { "TermNew" },
    config = function()
        vim.cmd([[
            let &shell = 'pwsh --nologo'
            let &shellcmdflag = '-NoLogo -NoProfile -ExecutionPolicy RemoteSigned -Command [Console]::InputEncoding=[Console]::OutputEncoding=[System.Text.Encoding]::UTF8;'
            set shellquote= shellxquote=
        ]])

        require('toggleterm').setup {
            highlights = {
                StatusLine = {
                    guibg = "#565F75",
                    guifg = "#6C7A96",
                },
            },
            size = 15,
            direction = 'horizontal',
            start_in_insert = true,
            auto_scroll = false
            -- persist_mode = false,
        }
    end
}
