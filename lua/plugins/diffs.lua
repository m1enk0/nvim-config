return {
    'barrettruth/diffs.nvim',
    event = "VeryLazy",
    config = function()
        vim.g.diffs = { 
            view = {
                prefix = false,
            },
            integrations = { fugitive = true, neogit = true, neojj = true, gitsigns = true, } 
        }
    end
}
