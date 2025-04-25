vim.cmd([[
    " try
    set nofixeol
    set fillchars=diff:⠀
    " try

    set pumheight=10
    set colorcolumn=140

    command! -nargs=* Scratch execute 'lua OpenInScratch(vim.fn.expand("<args>"))'
    set laststatus=3

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

    au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif "autojump to last position in the file
]])

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.termguicolors = true
vim.opt.signcolumn = "yes"
-- vim.o.viminfo = "'1000,<10000,s1000"
-- vim.o.viminfo = "'25,\"50"
vim.opt.splitright = true
vim.opt.title = true
vim.opt.titlestring = [[%{fnamemodify(getcwd(), ':t')} – %t]]
-- vim.opt.shada = ""

function OpenInScratch(param)
    local scratch_buf = vim.api.nvim_create_buf(false, true)
    if vim.fn.filereadable(param) == 1 then
        local content = vim.fn.readfile(param)
        vim.api.nvim_buf_set_lines(scratch_buf, 0, -1, false, content)
    end
    vim.api.nvim_set_current_buf(scratch_buf)
end

function SetProjectViminfo()
    local project_path = vim.fn.getcwd()
    local viminfo_dir = vim.fn.expand("~/.local/share/nvim/viminfo/")
    local viminfo_file = viminfo_dir .. vim.fn.fnamemodify(project_path, ':t') .. "_" .. vim.fn.sha256(project_path) .. ".viminfo"
    if vim.fn.isdirectory(viminfo_dir) == 0 then
        vim.fn.mkdir(viminfo_dir, "p", 0700) -- Set permissions to owner-only
    end
    vim.o.viminfofile = viminfo_file
    vim.cmd("silent! rviminfo " .. vim.fn.fnameescape(viminfo_file))
    vim.fn.getjumplist() -- Workaround for jump list bug
end

-- Add protection against accidental deletion
vim.api.nvim_create_autocmd("VimLeavePre", {
    callback = function()
        vim.cmd("silent! wviminfo! " .. vim.fn.fnameescape(viminfo_file))
    end,
    group = vim.api.nvim_create_augroup("PersistentViminfo", {clear = false})
})
-- Set up autocommands
vim.api.nvim_create_autocmd({"VimEnter", "DirChanged"}, {
    callback = SetProjectViminfo,
    group = vim.api.nvim_create_augroup("ProjectViminfo", {clear = true})
})