return {
    'stevearc/oil.nvim',
    lazy = false,
    opts = {},
    dependencies = { { "echasnovski/mini.icons", opts = {} } },
    config = function ()
        require("oil").setup({
            win_options = {
                foldcolumn = "1",
                number = false,
                relativenumber = false
            },
            view_options = {
                show_hidden = true,
            }
        })
    end
}
