vim.cmd([[
    set nofixeol
    set laststatus=3
    set fillchars=diff:⠀
    set shm+=I
    set pumheight=10
    set colorcolumn=140

    au TextYankPost * silent! lua vim.highlight.on_yank { higroup="VisualMode", timeout=250 }

    autocmd FocusGained, BufEnter * checktime

    autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o "disable auto comment next line

    au FileType gitcommit setlocal spell
]])

if vim.fn.has('win32') == 1 or vim.fn.has('win64') == 1 then
    vim.o.shell = "pwsh --nologo"
    vim.o.shellcmdflag = "-NoLogo -NoProfile -ExecutionPolicy RemoteSigned -Command [Console]::InputEncoding=[Console]::OutputEncoding=[System.Text.Encoding]::UTF8;"
    vim.o.shellredir = "2>&1 | Out-File -Encoding UTF8 %s; exit $LastExitCode"
    vim.o.shellpipe = "2>&1 | Out-File -Encoding UTF8 %s; exit $LastExitCode"
    vim.o.shellquote = ""
    vim.o.shellxquote = ""
end

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.termguicolors = true
vim.opt.signcolumn = "yes"
vim.opt.textwidth = 0
vim.opt.title = true
vim.opt.titlestring = [[%{fnamemodify(getcwd(), ':t')} – %t]]
vim.g.editorconfig = false
vim.diagnostic.config({
    virtual_text = true,
    signs = false,
    update_in_insert = false,
    severity_sort = true,
})
vim.opt.spelllang = { "en_us", "ru_yo" }
vim.opt.spelloptions = "camel"
vim.opt.spellcapcheck = "" -- disable first letter of sentence is capital check

function OpenInScratch(param)
    local scratch_buf = vim.api.nvim_create_buf(false, true)
    if vim.fn.filereadable(param) == 1 then
        local content = vim.fn.readfile(param)
        vim.api.nvim_buf_set_lines(scratch_buf, 0, -1, false, content)
    end
    vim.api.nvim_set_current_buf(scratch_buf)
end
vim.api.nvim_create_user_command("Scratch", function(opts) OpenInScratch(vim.fn.expand(opts.args)) end, { nargs = "*" })

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

vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
      vim.g.main_tab = vim.api.nvim_get_current_tabpage()
      vim.g.main_win = vim.api.nvim_get_current_win()
  end,
})

_G.statusline_hl = function()
	if vim.api.nvim_buf_get_name(0):match("^jdt://") or vim.api.nvim_buf_get_name(0):match("go.pkg.mod") then
		return "%#StatusLineLSP#"
	end
	return "%#StatusLine#"
end
vim.api.nvim_set_hl(0, "StatusLineLSP", { bg = "#3B4252" })

vim.api.nvim_create_user_command('StartLuaDebug', function() require("osv").launch({ port = 8086 }) end, {})
vim.api.nvim_create_user_command('StopLuaDebug', function() require("osv").stop() end, {})

vim.o.showtabline = 1

vim.o.tabline = '%!v:lua.MyTabLine()'
function _G.MyTabLine()
    local s = ''
    for i = 1, vim.fn.tabpagenr('$') do
        local winnr = vim.fn.tabpagewinnr(i)
        local buflist = vim.fn.tabpagebuflist(i)
        local bufnr = buflist[winnr]
        local name = vim.fn.fnamemodify(vim.fn.bufname(bufnr), ':t')
        if name == '' then
            name = '[No Name]'
        end
        if i == vim.fn.tabpagenr() then
            s = s .. '%#TabLineSel#'
        else
            s = s .. '%#TabLine#'
        end
        s = s .. ' ' .. name .. ' '
    end
    s = s .. '%#TabLineFill#'
    return s
end

if vim.fn.has("mac") == 1 then
    system_os = "mac"
elseif vim.fn.has("unix") == 1 then
    system_os = "linux"
elseif vim.fn.has("win32") == 1 or vim.fn.has("win64") == 1 then
    system_os = "win"
    vim.opt.shellslash = false -- Enable shellslash for Windows compatibility
    vim.defer_fn(function()
        vim.opt.shellslash = false
    end, 5000)
else
    print("OS not found, defaulting to 'linux'")
    system_os = "linux"
end

vim.api.nvim_del_augroup_by_name("nvim.popupmenu") -- 'nvim.popupmenu' messes up with amenu causes errors if menu is changed manually
vim.cmd([[
    aunmenu PopUp

    vnoremenu 1.007 PopUp.Copy "+y
    vnoremenu 1.008 PopUp.Paste "+p
    vnoremenu 1.009 PopUp.Highlight *``<Esc>

    nmenu 1.010 PopUp.Back <C-o>
    nmenu 1.020 PopUp.Forward <C-i>
    nmenu 1.030 PopUp.-sep_move- <NOP>
    nmenu 1.070 PopUp.Recent\ files <cmd>Telescope recent_files<cr>
    nmenu 1.080 PopUp.-sep_recents- <NOP>
    nmenu 1.090 PopUp.Close <A-f>
]])

vim.api.nvim_create_autocmd('LspAttach', {
    callback = function()
        vim.cmd[[
            nmenu 1.040 PopUp.Go\ to\ definition <cmd>lua vim.lsp.buf.definition()<cr>
            nmenu 1.050 PopUp.Go\ to\ references <cmd>Telescope lsp_references<cr>
            nmenu 1.060 PopUp.-sep_lsp- <NOP>
        ]]
    end,
})

vim.keymap.set("n", "<LeftMouse>", function() vim.opt.scrolloff = 0 return "<LeftMouse>" end, { expr = true })
vim.keymap.set("n", "<RightMouse>", function() vim.opt.scrolloff = 0 return "<RightMouse>" end, { expr = true })

vim.keymap.set("n", "zz", function() vim.opt.scrolloff = 999 return "zz" end, { expr = true })
vim.keymap.set("n", "<Enter>", "zz:set scrolloff=999<cr>", global.map_key_opts)

vim.g.diffs = { 
    view = {
        prefix = false,
    },
    integrations = { 
        fugitive = true, 
        gitsigns = true 
    } 
}

-- restore position within a file
vim.api.nvim_create_autocmd('BufReadPost', {
    callback = function(args)
        local valid_line = vim.fn.line([['"]]) >= 1 and vim.fn.line([['"]]) < vim.fn.line('$')
        local not_commit = vim.b[args.buf].filetype ~= 'commit'

        if valid_line and not_commit then
            vim.cmd([[normal! g`"]])
        end
    end,
})
