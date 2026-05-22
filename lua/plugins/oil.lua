return {
    'stevearc/oil.nvim',
    lazy = false,
    opts = {},
    config = function ()
        require("oil").setup({
            delete_to_trash = true,
            win_options = {
                foldcolumn = "1",
                number = false,
                relativenumber = false
            },
            keymaps = {
                ['<C-l>'] = false,
                ['<C-h>'] = false,
                ['<C-p>'] = false
            },
            -- columns = {
            --     'icon',
            --     'size',
            -- },
            -- view_options = {
            --     show_hidden = true,
            -- }
        })

        -- oil changes dir to current on save (when creating or removing files). Restoring initial dir on save here to avoid
        local initial_cwd = vim.fn.getcwd()
        vim.api.nvim_create_autocmd("BufWritePost", {
            pattern = "oil://*",
            callback = function(args)
                vim.cmd("cd " .. vim.fn.fnameescape(initial_cwd))
            end,
        })
    end
}
