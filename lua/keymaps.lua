local telescope_present, telescope = pcall(require, "telescope.builtin")
local oil_present, oil = pcall(require, "oil")
local harpoon_present, harpoon = pcall(require, "harpoon")

local terminals = {}

local function open_runterm(name)
    local t = terminals[name]

    if t and vim.api.nvim_buf_is_valid(t.buf) then
        if not t.tab or not vim.api.nvim_tabpage_is_valid(t.tab) then
            vim.cmd("tab split")
            vim.cmd("buffer " .. t.buf)
            terminals[name].tab = vim.api.nvim_get_current_tabpage()
            return
        end
        vim.api.nvim_set_current_tabpage(t.tab)
        vim.api.nvim_set_current_buf(t.buf)
        return
    end
    vim.cmd("tab split | term")
    vim.api.nvim_buf_set_name(0, name)
    vim.cmd("startinsert")
    terminals[name] = {
        buf = vim.api.nvim_get_current_buf(),
        tab = vim.api.nvim_get_current_tabpage(),
    }
end

local function get_visual_selection()
    vim.cmd('noau normal! "vy"')
    local text = vim.fn.getreg('v')
    text = string.gsub(text, "\n", "")
    if #text > 0 then return text else return '' end
end

local function map_telescope_nv(shortcut, telescopeFun)
    local actions = require("telescope.actions")
    global.map_key("v", shortcut, function() 
        local default_text = get_visual_selection()
        global.jump_to_main()
        telescopeFun({
            default_text = default_text,
            attach_mappings = function(_)
                actions.close:replace(function(prompt_bufnr)
                    vim.api.nvim_buf_delete(prompt_bufnr, { force = true })
                    vim.cmd("norm! gvl") -- 'l' is a fix one char trimming on gv
                end)
                return true
            end
        }) 
    end, global.map_key_opts)
    global.map_key("n", shortcut, telescopeFun, global.map_key_opts)
end

local function current_dir()
    local dir = oil.get_current_dir()
    if dir == nil then return vim.fn.fnamemodify(vim.fn.bufname(), ":p:h") else return dir end
end

global.map_key("n", "<A-BS>", "<cmd>on<cr>", global.map_key_opts)

-- Split actions for undo
global.map_key("i", "<Cr>", "<Cr><C-g>u", global.map_key_opts)
global.map_key("i", "<Space>", "<Space><C-g>u", global.map_key_opts)

-- Git
global.map_key('n', '<A-C-a>', '<cmd>!git add %<cr>', { silent = false })
global.map_key('n', '<S-A-a>', '<cmd>!git add %<cr>', { silent = false })
global.map_key('n', '<leader>kk', '<cmd>vertical Git<cr>', global.map_key_opts)
global.map_key('n', '<C-l>', '<cmd>vertical Git<cr>', global.map_key_opts)
global.map_key('n', '<leader>kq', '<cmd>Git difftool<cr>', global.map_key_opts)
global.map_key('n', '<leader>ka', '<cmd>Git blame<cr>', global.map_key_opts)

-- Moving lines
global.map_key("n", "<S-A-j>", "<cmd>silent! m .+1<CR>==", global.map_key_opts)
global.map_key("n", "<S-A-k>", "<cmd>silent! m .-2<CR>==", global.map_key_opts)
global.map_key("v", "<S-A-j>", ":<C-u>silent! '<,'>m '>+1<CR>gv", global.map_key_opts)
global.map_key("v", "<S-A-k>", ":<C-u>silent! '<,'>m '<-2<CR>gv", global.map_key_opts)

-- Duplicate lines
global.map_key("n", "<S-A-d>", "<cmd>t.<cr>", global.map_key_opts)
-- MAP_KEY("v", '<S-A-d>', "y'>p'[V']", MAP_KEY_OPTS)
global.map_key("v", '<S-A-d>', "y'>pgv", global.map_key_opts)

-- Lazy
global.map_key("n", "<leader>L", "<cmd>Lazy<cr>", global.map_key_opts)

-- Window nav
global.map_key("n", "<A-C-j>", "<C-w>j", global.map_key_opts)
global.map_key("n", "<A-C-k>", "<C-w>k", global.map_key_opts)
global.map_key("n", "<A-C-l>", "<C-w>l", global.map_key_opts)
global.map_key("n", "<A-C-h>", "<C-w>h", global.map_key_opts)
global.map_key("n", "<A-C-i>", "<cmd>vertical resize +5<cr>", global.map_key_opts)
global.map_key("n", "<A-C-o>", "<cmd>vertical resize -5<cr>", global.map_key_opts)
global.map_key("n", "<A-C-e>", "<cmd>horizontal resize +2<cr>", global.map_key_opts)
global.map_key("n", "<A-C-w>", "<cmd>horizontal resize -2<cr>", global.map_key_opts)

-- Qf nav
global.map_key("n", "<S-A-p>", "<cmd>cnext<cr>", global.map_key_opts)
global.map_key("n", "<S-A-u>", "<cmd>cprev<cr>", global.map_key_opts)

-- Tab nav 
global.map_key("n", "<S-A-h>", "<cmd>tabprev<cr>", global.map_key_opts)
global.map_key("n", "<S-A-l>", "<cmd>tabnext<cr>", global.map_key_opts)
global.map_key("n", "<leader>tq", "<cmd>tabclose<cr>", global.map_key_opts)
global.map_key("n", "<leader>tn", "<cmd>tab split<cr>", global.map_key_opts)
global.map_key("n", "<leader>tN", "<C-w>T", global.map_key_opts)
global.map_key("n", "<leader>to", "<cmd>tabonly<cr>", global.map_key_opts)
global.map_key("n", "<leader>ts", "<cmd>vs | Scratch %<cr>", global.map_key_opts)
global.map_key("n", "<leader>tS", "<cmd>vs | Scratch %<cr><C-w>T", global.map_key_opts)
global.map_key("n", "<leader>ty", function() open_runterm('runterm_one') end, global.map_key_opts)
global.map_key("n", "<leader>tu", function() open_runterm('runterm_two') end, global.map_key_opts)

-- Telescope
if telescope_present then
    map_telescope_nv("<leader>ff", telescope.find_files)
    map_telescope_nv("<leader>fg", telescope.live_grep)
    map_telescope_nv("<leader>fh", telescope.help_tags)
    global.map_key("n", "<leader>fp", telescope.pickers)
    global.map_key("n", "<leader>fd", function() telescope.fd({ find_command = { 'fd', '-t', 'd', '--no-ignore' } }) end)
    global.map_key("n", "<A-e>", "<cmd>Telescope recent_files<cr>", global.map_key_opts)
    global.map_key("n", "<leader>fr", telescope.resume, global.map_key_opts)
    -- MAP_KEY("n", "<C-l>", telescope.git_status, MAP_KEY_OPTS)
    global.map_key("n", "<leader>ks", telescope.git_stash, global.map_key_opts)
    global.map_key("n", "<leader>kb", telescope.git_branches, global.map_key_opts)
    global.map_key("n", "<leader>fw", "<cmd>Telescope current_buffer_fuzzy_find fuzzy=false case_mode=ignore_case<cr>", global.map_key_opts)

    global.map_key("n", "<leader>FF", function() telescope.find_files({ cwd = current_dir() }) end, global.map_key_opts)
    global.map_key("n", "<leader>FG", function() telescope.live_grep({ cwd = current_dir() }) end, global.map_key_opts)
    global.map_key("n", "<leader>FD", function() telescope.fd({ cwd = current_dir(), find_command = { 'fd', '-t', 'd', '--no-ignore' } }) end, global.map_key_opts)
    global.map_key("n", "<leader>gd", function() telescope.live_grep({ default_text = vim.fn.expand("<cword>") .. [[.*\{]] }) end, global.map_key_opts)
else
    global.map_key("n", "<leader>ff", ":e **/**<Left>")
    global.map_key("n", "<leader>fg", ":vimgrep // **<Left><Left><Left><Left>")
end

if harpoon_present then
    global.map_key("n", "<A-h>", '<cmd>lua require("harpoon.ui").toggle_quick_menu()<cr>', global.map_key_opts)
    global.map_key("n", "<A-n>", '<cmd>lua require("harpoon.mark").add_file()<cr>', global.map_key_opts)
    global.map_key("n", "<A-a>", '<cmd>lua require("harpoon.ui").nav_file(1)<cr>', global.map_key_opts)
    global.map_key("n", "<A-s>", '<cmd>lua require("harpoon.ui").nav_file(2)<cr>', global.map_key_opts)
    global.map_key("n", "<A-d>", '<cmd>lua require("harpoon.ui").nav_file(3)<cr>', global.map_key_opts)
    -- MAP_KEY("n", "<A-f>", '<cmd>lua require("harpoon.ui").nav_file(4)<cr>', MAP_KEY_OPTS)
    global.map_key("n", "<A-g>", '<cmd>lua require("harpoon.ui").nav_file(5)<cr>', global.map_key_opts)
    global.map_key("n", "<A-t>", '<cmd>lua require("harpoon.ui").nav_file(6)<cr>', global.map_key_opts)
end
global.map_key("n", "<A-f>", function() if vim.api.nvim_get_current_win() ~= vim.g.main_win then vim.cmd('silent! close') end end, global.map_key_opts)

-- Gitsings
global.map_key("n", "<C-A-d>", "<cmd>Gitsigns nav_hunk next<cr>", global.map_key_opts)
global.map_key("n", "<C-A-u>", "<cmd>Gitsigns nav_hunk prev<cr>", global.map_key_opts)
global.map_key("n", "<leader>kd", "<cmd>Gitsigns nav_hunk next<cr>", global.map_key_opts)
global.map_key("n", "<leader>ku", "<cmd>Gitsigns nav_hunk prev<cr>", global.map_key_opts)
global.map_key("n", "<A-d>", "<cmd>Gitsigns nav_hunk next<cr>", global.map_key_opts)
global.map_key("n", "<A-u>", "<cmd>Gitsigns nav_hunk prev<cr>", global.map_key_opts)
global.map_key({ "n", "v" }, "<A-z>", ":Gitsigns reset_hunk<cr>", global.map_key_opts)
global.map_key("n", "<leader>ss", "<cmd>Gitsigns preview_hunk<cr>", global.map_key_opts)

-- Terminal
global.map_key("t", "<Esc>", "<C-\\><C-n>", global.map_key_opts)
global.map_key("t", "<A-y>", "<C-\\><C-n><cmd>ToggleTerm<cr>", global.map_key_opts)

vim.api.nvim_create_autocmd("FileType", {
    pattern = "json",
    callback = function()
        global.map_key("v", "<leader>f", "<cmd>CocCommand formatJson.selected --indent=4<cr>", { buffer = true })
        global.map_key("n", "<leader>fa", "<cmd>CocCommand formatJson --indent=4<cr>", { buffer = true })
        global.map_key("n", "<leader>f", "<Nop>")
    end
})

vim.api.nvim_create_autocmd("FileType", {
    pattern = "qf",
    callback = function()
        global.map_key("n", "<cr>", "<cr><cmd>copen<cr>", { buffer = true })
        global.map_key("n", "q", "<cmd>cclose<cr>", { buffer = true })
        global.map_key("n", "<A-CR>", "<cr><cmd>cclose<cr>", { buffer = true })
        global.map_key("n", "<esc>", "<cmd>cclose<cr>", { buffer = true })
        global.map_key("n", "x", "<cmd>.Reject<cr>", { buffer = true })
        global.map_key("v", "x", ":Reject<cr>", { buffer = true })
    end
})

-- LSP
if telescope_present then
    global.map_key("n", "grr", telescope.lsp_references, global.map_key_opts)
    global.map_key("n", "<A-p>", telescope.lsp_document_symbols, global.map_key_opts)
    global.map_key("n", "<leader>gi", telescope.lsp_implementations, global.map_key_opts)
else
    global.map_key("n", "grr", vim.lsp.buf.references, global.map_key_opts)
    global.map_key("n", "<A-p>", vim.lsp.buf.document_symbols, global.map_key_opts)
    global.map_key("n", "<leader>gi", vim.lsp.buf.implementation, global.map_key_opts)
end

global.map_key("n", "gd", "<C-]>", global.map_key_opts)
vim.api.nvim_create_autocmd('LspAttach', {
    callback = function()
        global.map_key("n", "gd", vim.lsp.buf.definition, global.map_key_opts)
    end,
})
global.map_key("n", "]]", vim.diagnostic.goto_next, global.map_key_opts)
global.map_key("n", "[[", vim.diagnostic.goto_prev, global.map_key_opts)
global.map_key("n", "<A-CR>", vim.lsp.buf.code_action, global.map_key_opts)
global.map_key("n", "<A-o>", vim.diagnostic.open_float, global.map_key_opts)
global.map_key("v", "<A-CR>", vim.lsp.buf.code_action, global.map_key_opts)
global.map_key("n", "<S-A-f>", vim.lsp.buf.format, global.map_key_opts)
global.map_key("v", "<S-A-f>", vim.lsp.buf.format, global.map_key_opts)
global.map_key("n", "<C-p>", vim.lsp.buf.signature_help, global.map_key_opts)
global.map_key("i", "<C-p>", vim.lsp.buf.signature_help, global.map_key_opts)
global.map_key("n", "<A-r>", vim.lsp.buf.rename, global.map_key_opts)
global.map_key("n", "<leader>ah", vim.lsp.buf.hover, global.map_key_opts)
global.map_key("n", "<leader>ls", "<cmd>LspStart<cr>", global.map_key_opts)
global.map_key("n", "<leader>lr", "<cmd>LspRestart<cr>", global.map_key_opts)

if oil_present then
    global.map_key("n", "-", oil.open, global.map_key_opts)
else
    global.map_key("n", "-", "<cmd>Explore<cr>", global.map_key_opts)
end

global.map_key("v", "<leader>fj", ":!jq .<cr>", global.map_key_opts)

-- Settings
global.map_key("n", "<leader>sw", "<cmd>set wrap!<cr>", global.map_key_opts)
global.map_key("n", "<leader>sp", "<cmd>silent! setlocal spell! spelloptions=camel spelllang=ru_yo,en_us<cr>", global.map_key_opts)

-- Alacritty specific mappings
global.map_key("n", "<C-Left>", "<C-w>h", global.map_key_opts)
global.map_key("n", "<C-Down>", "<C-w>j", global.map_key_opts)
global.map_key("n", "<C-Up>", "<C-w>k", global.map_key_opts)
global.map_key("n", "<C-Right>", "<C-w>l", global.map_key_opts)
global.map_key("n", "<C-A-Right>", "<cmd>vertical resize +5<cr>", global.map_key_opts)
global.map_key("n", "<C-A-Left>", "<cmd>vertical resize -5<cr>", global.map_key_opts)
global.map_key("n", "<C-A-Up>", "<cmd>horizontal resize +2<cr>", global.map_key_opts)
global.map_key("n", "<C-A-Down>", "<cmd>horizontal resize -2<cr>", global.map_key_opts)

global.map_key("n", "<leader>ip", "<cmd>echon expand('%:P')<cr>", global.map_key_opts)
global.map_key("n", "<leader>iP", "<cmd>echon expand('%:p')<cr>", global.map_key_opts)


global.map_key("v", "<leader>kc", 'y:G checkout <C-r>\"', { noremap = true })
global.map_key("n", "<leader>kl", "<cmd>:G log --all --pretty=oneline -1000<cr>", { noremap = true })

if telescope_present then 
    global.map_key("n", "<S-Del>", function ()
        local toggleterm_present, toggleterm = pcall(require, "toggleterm")
        if not toggleterm_present then 
            return
        end
        local actions = require('telescope.actions')
        local action_state = require('telescope.actions.state')
        telescope.find_files({ 
            prompt_title = "Execute",
            cwd = vim.fn.getcwd() .. "/build-scripts",
            attach_mappings = function(prompt_bufnr, map)
                map('i', '<CR>', function()
                    local selection = action_state.get_selected_entry()
                    actions.close(prompt_bufnr)
                    if selection then
                        local ok, content = pcall(vim.fn.readfile, selection.path)
                        if not ok then
                            vim.notify("Failed to read " .. selection.path, vim.log.levels.ERROR)
                            return
                        end
                        toggleterm.exec(table.concat(content, " "), 0, 0, nil, nil, nil, false)
                    else
                        vim.notify('No file selected', vim.log.levels.WARN)
                    end
                end)
                return true
            end,
        })
    end, global.map_key_opts)
end
