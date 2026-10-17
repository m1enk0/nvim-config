return {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    lazy = false,
    branch = "master",
    config = function()
        local configs = require("nvim-treesitter.configs")
        configs.setup({
            ensure_installed = { "java", --[[ "bash", ]] "yaml", "javascript", --[[ "groovy", ]] "kotlin", "lua" },
            highlight = {
                enable = true,
                additional_vim_regex_highlighting = false,
            },
        })
        -- vim.api.nvim_create_autocmd("FileType", {
        --     pattern = "*",
        --     callback = function()
        --         vim.defer_fn(function()
        --             vim.cmd(":TSBufEnable highlight")
        --         end, 0)
        --     end,
        -- })

        vim.treesitter.query.set("markdown", "injections", "") -- fix for markdown range error (after updating to nvim 0.12)
    end
}
