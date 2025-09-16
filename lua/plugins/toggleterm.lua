return {
    'akinsho/toggleterm.nvim',
    keys = {
        { "<A-y>", "<cmd>ToggleTerm<cr>" },
    },
    cmd = { "TermNew" },
    config = function()
        local is_windows = vim.fn.has('win32') == 1 or vim.fn.has('win64') == 1
        if is_windows then
            vim.cmd([[
                let &shell = 'pwsh --nologo'
                let &shellcmdflag = '-NoLogo -NoProfile -ExecutionPolicy RemoteSigned -Command [Console]::InputEncoding=[Console]::OutputEncoding=[System.Text.Encoding]::UTF8;'
                set shellquote= shellxquote=
            ]])
        end

        require('toggleterm').setup {
            highlights = {
                StatusLine = {
                    guibg = "#565F75",
                    guifg = "#6C7A96",
                },
            },
            size = 15,
            direction = 'horizontal',
            start_in_insert = false,
            auto_scroll = false
            -- persist_mode = false,
        }
    end
}
