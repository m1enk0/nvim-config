vim.cmd([[
    hi Visual guibg=#3165CF gui=none
    hi Normal guibg=NONE ctermbg=NONE

    au TextYankPost * silent! lua vim.highlight.on_yank {timeout=400}
]])
