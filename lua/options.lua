vim.cmd([[
    " try
    " set noendofline binary
    set nofixendofline
    command! Scratch execute 'enew' | setlocal buftype=nofile bufhidden=hide noswapfile
    let g:netrw_fastbrowse = 2
    set fileformat=dos
    " try

    set shada=
    set pumheight=10
    set colorcolumn=120

    au TextYankPost * silent! lua vim.highlight.on_yank { higroup="VisualMode", timeout=250 }

    set autoread
    autocmd FocusGained, BufEnter * checktime

    highlight WordUnderCursor guibg=#3B4252
    augroup HighlightWordUnderCursor
        autocmd!
        autocmd CursorMoved * call HighlightIfMultipleMatches()
    augroup END
    function! HighlightIfMultipleMatches()
        let word = expand('<cword>')
        try
            if len(filter(getline(getpos('w0')[1], getpos('w$')[1]), 'v:val =~ "\\<" . word . "\\>"')) > 1
                exec 'match WordUnderCursor /\V\<' . word . '\>/'
            else
                exec 'match none'
            endif
        catch /./
        endtry
    endfunction
]])

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.termguicolors = true
vim.opt.signcolumn = "yes"

vim.opt.title = true
vim.opt.titlestring = [[%{fnamemodify(getcwd(), ':t')} — %t]]

-- function SetProjectViminfo()
--     -- Get the full path of the current directory
--     local project_path = vim.fn.getcwd()
--     local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ':t') -- Get project folder name
--
--     -- Generate a hash of the project path to ensure uniqueness
--     local project_hash = vim.fn.sha256(project_path)
--     local viminfo_dir = vim.fn.expand("~/.local/share/nvim/viminfo/")
--     local viminfo_file = viminfo_dir .. project_name .. project_hash .. ".viminfo"
--
--     -- Create the viminfo directory if it doesn't exist
--     if vim.fn.isdirectory(viminfo_dir) == 0 then
--         vim.fn.mkdir(viminfo_dir, "p")
--     end
--
--     -- Set the viminfofile and load the viminfo data for the current project
--     vim.o.viminfofile = viminfo_file
--     vim.cmd("silent! rviminfo " .. viminfo_file) --
--
--     vim.fn.getjumplist()                         -- bug workaround
-- end
--
-- vim.cmd([[
--     autocmd VimEnter * lua SetProjectViminfo()
--     autocmd DirChanged * lua SetProjectViminfo()
--     autocmd VimLeavePre * silent! wviminfo!
-- ]])