return {
    'lewis6991/gitsigns.nvim',
    event = "VeryLazy",
    config = function()
        require('gitsigns').setup({
            diff_opts = {
                internal = false
            },
            on_attach = function(bufnr)
                vim.api.nvim_set_hl(0, 'GitSignsAdd', { fg = '#385538', bg = 'NONE' })
                vim.api.nvim_set_hl(0, 'GitSignsChange', { fg = '#374861', bg = 'NONE' })
            end
        })
    end
}
