return {
    'tpope/vim-fugitive',
    event = "VeryLazy",
    config = function()
        vim.cmd[[
            function! FugitiveStatusContent()
                let branch = matchstr(fugitive#statusline(), '(\zs.\{-}\ze)')
                return empty(branch) ? '' : ' ' . branch
            endfunction
            set statusline=%{%v:lua.statusline_hl()%}\ %<%t\ %h%m%r%=%-14.(%{FugitiveStatusContent()}\ \ %l,%c%V%)\ %p%%

            " set statusline=\ %<%t\ %h%m%r             " Left section
            " set statusline+=%=                        " Center align
            " set statusline+=\ %S\                     " MIDDLE: showcmd with spacing
            " set statusline+=%=                        " Right align from here
            " set statusline+=%-14.(\ %{FugitiveStatusContent()}\ %l,%c%V%)
            " set statusline+=\ %p%%\ %{SearchStatus()}
        ]]
    end
}