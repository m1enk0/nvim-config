return {
    'akinsho/toggleterm.nvim',
    keys = {
        { "<A-y>", "<cmd>ToggleTerm 1<cr>" },
        { "<C-y>", "<cmd>ToggleTerm 2<cr>" },
        { "<C-u>", "<cmd>ToggleTerm 3<cr>" },
    },
    cmd = { "TermNew" },
    config = function()
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
