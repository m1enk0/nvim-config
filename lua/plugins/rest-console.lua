return {
    'diepm/vim-rest-console',
    ft = 'rest',
    config = function ()
        vim.cmd('let g:vrc_trigger = "<A-Enter>"')
    end
}
