return {
    'tpope/vim-fugitive',
    event = "VeryLazy",
    config = function()
        vim.cmd[[
            highlight GitBranch guifg=#84858B
            function! IMInsertStatus() abort
                return &l:iminsert == 1 ? '󰥻 RU' : ''
            endfunction
            function! FugitiveStatusContent()
                let branch = matchstr(fugitive#statusline(), '(\zs.\{-}\ze)')
                return empty(branch) ? '' : ' ' . branch
            endfunction
            set statusline=%{%v:lua.statusline_hl()%}\ %<%t\ %h%m%r%=%{IMInsertStatus()}\ \ %#GitBranch#%{FugitiveStatusContent()}%#StatusLine#\ \ %l,%c%V\ %p%%
        ]]
    end
}
