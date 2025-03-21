vim.cmd([[
    " try
    command! -nargs=* Scratch execute 'lua OpenInScratch(vim.fn.expand("<args>"))'
    set nofixeol
    set fillchars=diff:⠀
    set laststatus=3
    " try

    set shada=
    set pumheight=10
    set colorcolumn=120

    au TextYankPost * silent! lua vim.highlight.on_yank { higroup="VisualMode", timeout=250 }

    set autoread
    autocmd FocusGained, BufEnter * checktime

    hi WordUnderCursor guibg=#3B4252
    nnoremap <leader>3 <CMD>exec 'match WordUnderCursor /\V\<' . expand('<cword>') . '\>/'<cr>
    nnoremap <Esc> <Esc><cmd>exec 'match none'<cr>

    function! s:ZoomToggle() abort
        if exists('t:zoomed') && t:zoomed
            execute t:zoom_winrestcmd
            let t:zoomed = 0
        else
            let t:zoom_winrestcmd = winrestcmd()
            resize
            vertical resize
            let t:zoomed = 1
        endif
    endfunction

    command! ZoomToggle call s:ZoomToggle()
    nnoremap <silent> <leader><BS> :ZoomToggle<CR>

    autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o "disable auto comment next line
]])

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.termguicolors = true
vim.opt.signcolumn = "yes"
vim.o.viminfo = "'1000,<10000,s1000"
vim.opt.splitright = true
vim.opt.title = true
vim.opt.titlestring = [[%{fnamemodify(getcwd(), ':t')} – %t]]

function OpenInScratch(param)
    local scratch_buf = vim.api.nvim_create_buf(false, true)
    if vim.fn.filereadable(param) == 1 then
        local content = vim.fn.readfile(param)vim.fn.readfile(param)
        vim.api.nvim_buf_set_lines(scratch_buf, 0, -1, false, content)
    end
    vim.api.nvim_set_current_buf(scratch_buf)
end

function SetProjectViminfo()
    local project_path = vim.fn.getcwd()
    local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ':t') -- Get project folder name
    local project_hash = vim.fn.sha256(project_path)
    local viminfo_dir = vim.fn.expand("~/.local/share/nvim/viminfo/")
    local viminfo_file = viminfo_dir .. project_name .. project_hash .. ".viminfo"
    if vim.fn.isdirectory(viminfo_dir) == 0 then
        vim.fn.mkdir(viminfo_dir, "p")
    end
    vim.o.viminfofile = viminfo_file
    vim.cmd("silent! rviminfo " .. viminfo_file)

    vim.fn.getjumplist()                         -- bug workaround
end

vim.cmd([[
    autocmd VimEnter * lua SetProjectViminfo()
    autocmd DirChanged * lua SetProjectViminfo()
    autocmd VimLeavePre * silent! wviminfo!
]])