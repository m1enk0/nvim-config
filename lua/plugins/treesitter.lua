return {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    event = "VeryLazy",
    config = function()
        local configs = require("nvim-treesitter.configs")
        configs.setup({
            highlight = {
                additional_vim_regex_highlighting = false,
            },
        })
        vim.api.nvim_create_autocmd("FileType", {
            pattern = "*", 
            callback = function()
                vim.defer_fn(function()
                    vim.cmd(":TSBufEnable highlight")
                end, 0)
            end,
        })
    end
}
