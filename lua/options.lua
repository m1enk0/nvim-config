vim.cmd([[

    " set showcmdloc=statusline
    " set cmdheight=0
    " function! SearchStatus()
    "     if !v:hlsearch || @/ == '' || mode() != 'n'
    "         return ''
    "     endif
    "     
    "     let result = searchcount({'maxcount': 0, 'timeout': 100})
    "     if result.total > 0
    "         let current = result.current > 0 ? result.current : 1
    "         return printf('[%d/%d]', current, result.total)
    "     endif
    "     
    "     return ''
    " endfunction

    " function! MyTabLine()
    "   let s = ''
    "   for i in range(tabpagenr('$'))
    "     let tab = i + 1
    "     let winnr = tabpagewinnr(tab)
    "     let buflist = tabpagebuflist(tab)
    "     let bufnr = buflist[winnr - 1]
    "     let bufname = bufname(bufnr)
    "     
    "     " Get filename and truncate if too long
    "     let filename = fnamemodify(bufname, ':t')
    "     if strlen(filename) > 40
    "       let filename = filename[0:14] . '..'
    "     elseif filename == ''
    "       let filename = '[No Name]'
    "     endif
    "     
    "     let s .= '%' . tab . 'T'
    "     let s .= (tab == tabpagenr() ? '%#TabLineSel#' : '%#TabLine#')
    "     let s .= ' ' . filename . ' '
    "   endfor
    "   let s .= '%#TabLineFill#%T'
    "   return s
    " endfunction
    "
    " set tabline=%!MyTabLine()
    " try
    set nofixeol
    set fillchars=diff:⠀
    set shm+=I
    set shada=!,'10000,<50,s10,h,f1
    " set shada=!,'100,<50,s10,h
    " try

    set pumheight=10
    set colorcolumn=140

    command! -nargs=* Scratch execute 'lua OpenInScratch(vim.fn.expand("<args>"))'
    set laststatus=3

    au TextYankPost * silent! lua vim.highlight.on_yank { higroup="VisualMode", timeout=250 }

    set autoread
    autocmd FocusGained, BufEnter * checktime

    hi WordUnderCursor guibg=#355655
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
vim.g.undotree_DiffCommand = "FC"
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
