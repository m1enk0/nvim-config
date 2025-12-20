return {
    'stevearc/oil.nvim',
    lazy = false,
    opts = {},
    config = function ()
        require("oil").setup({
            win_options = {
                foldcolumn = "1",
                number = false,
                relativenumber = false
            },
            -- columns = {
            --     'icon',
            --     'size',
            -- },
            -- view_options = {
            --     show_hidden = true,
            -- }
        })
    end
}
