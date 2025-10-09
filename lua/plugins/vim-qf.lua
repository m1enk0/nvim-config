return {
    "romainl/vim-qf",
    event = "VeryLazy",
    keys = {
        { "<A-S-o>", "<cmd>call ToggleQuickfix()<cr>" }
    },
    config = function()
        vim.cmd[[
            let g:qf_mapping_ack_style = 1

            function! ToggleQuickfix()
                if &buftype ==# 'quickfix'
                    cclose 
                    return
                endif
                for win in range(1, winnr('$'))
                    if getwinvar(win, '&buftype') ==# 'quickfix'
                        exe win . "wincmd w"
                        return
                    endif
                endfor
                call qf#toggle#ToggleQfWindow(0)
            endfunction
        ]]
    end
}
