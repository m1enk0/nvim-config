return {
    'ivechan/gtags.vim',
    event = "VeryLazy",
    config = function ()
        vim.cmd[[
            let Gtags_Close_When_Single = 1
            let Gtags_Auto_Update = 0
            let g:cscope_silent = 1
        ]]
    end
}
