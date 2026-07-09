return {
    'tpope/vim-fugitive',
    event = "VeryLazy",
    config = function()
        vim.cmd[[
            highlight GitBranch guifg=#72737A
            function! FugitiveStatusContent()
                let branch = matchstr(fugitive#statusline(), '(\zs.\{-}\ze)')
                return empty(branch) ? '' : ' ' . branch
            endfunction
            set statusline=%{%v:lua.statusline_hl()%}\ %<%t\ %h%m%r%=%#GitBranch#%{FugitiveStatusContent()}%#StatusLine#\ \ %l,%c%V\ %p%%
        ]]
    end
}