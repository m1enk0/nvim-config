return {
    'lewis6991/gitsigns.nvim',
    tag = 'v0.9.0',
    event = "VeryLazy",
    config = function()
        require('gitsigns').setup({
            diff_opts = {
                internal = false
            }
        })
    end
}
