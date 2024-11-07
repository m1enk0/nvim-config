vim.cmd([[
    set shada=
    set pumheight=10
    set pumblend=20


    hi Visual guibg=#3165CF gui=none
    hi Normal guibg=NONE ctermbg=NONE

    au TextYankPost * silent! lua vim.highlight.on_yank { higroup="VisualMode", timeout=400 }
]])

function SetProjectViminfo()
    -- Get the full path of the current directory
    local project_path = vim.fn.getcwd()
    local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ':t') -- Get project folder name

    -- Generate a hash of the project path to ensure uniqueness
    local project_hash = vim.fn.sha256(project_path)
    local viminfo_dir = vim.fn.expand("~/.local/share/nvim/viminfo/")
    local viminfo_file = viminfo_dir .. project_name .. project_hash .. ".viminfo"

    -- Create the viminfo directory if it doesn't exist
    if vim.fn.isdirectory(viminfo_dir) == 0 then
    vim.fn.mkdir(viminfo_dir, "p")
    end

    -- Set the viminfofile and load the viminfo data for the current project
    vim.o.viminfofile = viminfo_file
    vim.cmd("silent! rviminfo " .. viminfo_file) --

    vim.fn.getjumplist() -- bug workaround
end

vim.cmd([[
    autocmd VimEnter * lua SetProjectViminfo()
    autocmd DirChanged * lua SetProjectViminfo()
    autocmd VimLeavePre * silent! wviminfo!
]])
