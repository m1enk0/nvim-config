return {
    'tpope/vim-fugitive',
    event = "VeryLazy",
    config = function()
        vim.cmd[[
            function! FugitiveStatusContent()
                return matchstr(fugitive#statusline(), '(\zs.\{-}\ze)')
            endfunction
            set statusline=%<%t\ %h%m%r%=%-14.(\\ %{FugitiveStatusContent()}\ \ %l,%c%V%)\ %p%%
        ]]
    end
}