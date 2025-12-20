vim.cmd([[
    " try
    set nofixeol
    set fillchars=diff:⠀
    set shm+=I
    set shada=!,'10000,<50,s10,h,f1
    " try

    set pumheight=10
    set colorcolumn=140

    command! -nargs=* Scratch execute 'lua OpenInScratch(vim.fn.expand("<args>"))'
    set laststatus=3

    au TextYankPost * silent! lua vim.highlight.on_yank { higroup="VisualMode", timeout=250 }

    autocmd FocusGained, BufEnter * checktime

    hi WordUnderCursor guibg=#355655

    inoremap <expr> ) CheckPair('(', ')')
    inoremap <expr> ' CheckPair("'", "'")
    inoremap <expr> " CheckPair('"', '"')
    inoremap <expr> ] CheckPair('[', ']')
    inoremap <expr> } CheckPair('{', '}')
    inoremap <expr> > CheckPair('<', '>')
    inoremap <expr> <cr> SmartNewLine('{', '}')

    function! SmartNewLine(opening, closing) 
        let line = getline('.')
        let col = col('.')
        let prev_char = col > 1 ? line[col - 2] : ''
        let next_char = col <= len(line) ? line[col - 1] : ''
        return prev_char ==# a:opening && next_char ==# a:closing ? "\<cr>\<Esc>O" : "\<cr>"
    endfunction

    function! CheckPair(opening, closing)
        let line = getline('.')
        let prev_char = line[col('.')-2]
        return prev_char ==# a:opening ? a:closing . "\<Left>" : a:closing
    endfunction

    autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o "disable auto comment next line

    au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") | exe "normal! g'\"" | endif "autojump to last position in the file
]])

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.termguicolors = true
vim.opt.signcolumn = "yes"
vim.opt.textwidth = 0
-- vim.o.viminfo = "'1000,<10000,s1000"
-- vim.o.viminfo = "'25,\"50"
vim.opt.title = true
vim.opt.titlestring = [[%{fnamemodify(getcwd(), ':t')} – %t]]
vim.g.editorconfig = false

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

    -- Add protection against accidental deletion
    vim.api.nvim_create_autocmd("VimLeavePre", {
        callback = function()
            vim.cmd("silent! wviminfo! " .. vim.fn.fnameescape(viminfo_file))
        end,
        group = vim.api.nvim_create_augroup("PersistentViminfo", {clear = false})
    })
end

-- Set up autocommands
vim.api.nvim_create_autocmd({"VimEnter", "DirChanged"}, {
    callback = SetProjectViminfo,
    group = vim.api.nvim_create_augroup("ProjectViminfo", {clear = true})
})

vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter", "DirChanged" }, {
    pattern = "oil://*",
    callback = function()
        local oil = require("oil")
        local cwd = oil.get_current_dir()
        if cwd then
            vim.wo.winbar = "Oil: " .. cwd -- show only folder name
        end
    end,
})
