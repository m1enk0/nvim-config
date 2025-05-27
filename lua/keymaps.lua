MAP_KEY = vim.keymap.set
MAP_KEY_OPTS = { noremap = true, silent = true }

local function getVisualSelection()
    vim.cmd('noau normal! "vy"')
    local text = vim.fn.getreg('v')
    text = string.gsub(text, "\n", "")
    if #text > 0 then return text else return '' end
end

local function mapTelescopeNV(shortcut, telescopeFun)
    local actions = require("telescope.actions")
    MAP_KEY("v", shortcut, function() telescopeFun({
        default_text = getVisualSelection(),
        attach_mappings  = function(_)
            actions.close:replace(function(prompt_bufnr)
                vim.api.nvim_buf_delete(prompt_bufnr, { force = true })
                vim.cmd("norm! gvl") -- 'l' is a fix one char trimming on gv
            end)
            return true
        end
    }) end, MAP_KEY_OPTS)
    MAP_KEY("n", shortcut, telescopeFun, MAP_KEY_OPTS)
end

local function current_dir()
    local dir = require("oil").get_current_dir()
    if dir == nil then return vim.fn.fnamemodify(vim.fn.bufname(), ":p:h") else return dir end
end

MAP_KEY("n", "<A-BS>", "<cmd>on<cr>", MAP_KEY_OPTS)

-- Split actions for undo
MAP_KEY("i", "<Cr>", "<Cr><C-g>u", MAP_KEY_OPTS)
MAP_KEY("i", "<Space>", "<Space><C-g>u", MAP_KEY_OPTS)

-- Git
MAP_KEY('n', '<A-C-a>', '<cmd>!git add %<cr>', { silent = false })
MAP_KEY('n', '<leader>kk', '<cmd>vertical Git<cr>', MAP_KEY_OPTS)
MAP_KEY('n', '<leader>kq', '<cmd>Git difftool<cr>', MAP_KEY_OPTS)

-- Moving lines
MAP_KEY("n", "<S-A-j>", "<cmd>silent! m .+1<CR>==", MAP_KEY_OPTS)
MAP_KEY("n", "<S-A-k>", "<cmd>silent! m .-2<CR>==", MAP_KEY_OPTS)
MAP_KEY("v", "<S-A-j>", ":<C-u>silent! '<,'>m '>+1<CR>gv", MAP_KEY_OPTS)
MAP_KEY("v", "<S-A-k>", ":<C-u>silent! '<,'>m '<-2<CR>gv", MAP_KEY_OPTS)

-- Duplicate lines
MAP_KEY("n", "<S-A-d>", "<cmd>t.<cr>", MAP_KEY_OPTS)
MAP_KEY("v", '<S-A-d>', "y'>p'[V']", MAP_KEY_OPTS)

-- Lazy
MAP_KEY("n", "<leader>L", "<cmd>Lazy<cr>", MAP_KEY_OPTS)

-- Window nav
MAP_KEY("n", "<A-C-j>", "<C-w>j", MAP_KEY_OPTS)
MAP_KEY("n", "<A-C-k>", "<C-w>k", MAP_KEY_OPTS)
MAP_KEY("n", "<A-C-l>", "<C-w>l", MAP_KEY_OPTS)
MAP_KEY("n", "<A-C-h>", "<C-w>h", MAP_KEY_OPTS)
MAP_KEY("n", "<A-C-i>", "<cmd>vertical resize +5<cr>", MAP_KEY_OPTS)
MAP_KEY("n", "<A-C-o>", "<cmd>vertical resize -5<cr>", MAP_KEY_OPTS)
MAP_KEY("n", "<A-C-e>", "<cmd>horizontal resize +2<cr>", MAP_KEY_OPTS)
MAP_KEY("n", "<A-C-w>", "<cmd>horizontal resize -2<cr>", MAP_KEY_OPTS)

-- Qf nav
MAP_KEY("n", "<S-A-o>", "<cmd>cnext<cr>", MAP_KEY_OPTS)
MAP_KEY("n", "<S-A-u>", "<cmd>cprev<cr>", MAP_KEY_OPTS)

-- Tab nav 
MAP_KEY("n", "<S-A-h>", "<cmd>tabprev<cr>", MAP_KEY_OPTS)
MAP_KEY("n", "<S-A-l>", "<cmd>tabnext<cr>", MAP_KEY_OPTS)
MAP_KEY("n", "<leader>tq", "<cmd>tabclose<cr>", MAP_KEY_OPTS)
MAP_KEY("n", "<leader>tn", "<cmd>tab split<cr>", MAP_KEY_OPTS)
MAP_KEY("n", "<leader>to", "<cmd>tabonly<cr>", MAP_KEY_OPTS)
MAP_KEY("n", "<leader>ts", "<cmd>vs | Scratch %<cr>", MAP_KEY_OPTS)

-- Telescope
local ok, telescope = pcall(require, "telescope.builtin")
if ok then
    mapTelescopeNV("<leader>ff", telescope.find_files)
    mapTelescopeNV("<leader>fg", telescope.live_grep)
    mapTelescopeNV("<leader>fh", telescope.help_tags)
    MAP_KEY("n", "<leader>fp", telescope.pickers)
    MAP_KEY("n", "<leader>fd", function() telescope.fd({ find_command = { 'fd', '-t', 'd', '--no-ignore' } }) end)
    MAP_KEY("n", "<A-e>", "<cmd>Telescope recent_files<cr>", MAP_KEY_OPTS)
    MAP_KEY("n", "<leader>fr", telescope.resume, MAP_KEY_OPTS)
    MAP_KEY("n", "<C-l>", telescope.git_status, MAP_KEY_OPTS)
    MAP_KEY("n", "<leader>ks", telescope.git_stash, MAP_KEY_OPTS)
    MAP_KEY("n", "<leader>kb", telescope.git_branches, MAP_KEY_OPTS)
    MAP_KEY("n", "<leader>fw", "<cmd>Telescope current_buffer_fuzzy_find fuzzy=false case_mode=ignore_case<cr>", MAP_KEY_OPTS)

    MAP_KEY("n", "<leader>FF", function() telescope.find_files({ cwd = current_dir() }) end, MAP_KEY_OPTS)
    MAP_KEY("n", "<leader>FG", function() telescope.live_grep({ cwd = current_dir() }) end, MAP_KEY_OPTS)
    MAP_KEY("n", "<leader>gd", function() require('telescope.builtin').live_grep({ default_text = vim.fn.expand("<cword>") .. [[.*\{]] }) end, MAP_KEY_OPTS)
end

-- Harpoon
MAP_KEY("n", "<A-h>", '<cmd>lua require("harpoon.ui").toggle_quick_menu()<cr>', MAP_KEY_OPTS)
MAP_KEY("n", "<A-n>", '<cmd>lua require("harpoon.mark").add_file()<cr>', MAP_KEY_OPTS)
MAP_KEY("n", "<A-a>", '<cmd>lua require("harpoon.ui").nav_file(1)<cr>', MAP_KEY_OPTS)
MAP_KEY("n", "<A-s>", '<cmd>lua require("harpoon.ui").nav_file(2)<cr>', MAP_KEY_OPTS)
MAP_KEY("n", "<A-d>", '<cmd>lua require("harpoon.ui").nav_file(3)<cr>', MAP_KEY_OPTS)
MAP_KEY("n", "<A-f>", '<cmd>lua require("harpoon.ui").nav_file(4)<cr>', MAP_KEY_OPTS)
MAP_KEY("n", "<A-g>", '<cmd>lua require("harpoon.ui").nav_file(5)<cr>', MAP_KEY_OPTS)
MAP_KEY("n", "<A-t>", '<cmd>lua require("harpoon.ui").nav_file(6)<cr>', MAP_KEY_OPTS)

-- Gitsings
MAP_KEY("n", "<C-A-d>", "<cmd>Gitsigns next_hunk<cr>", MAP_KEY_OPTS)
MAP_KEY("n", "<C-A-u>", "<cmd>Gitsigns prev_hunk<cr>", MAP_KEY_OPTS)
MAP_KEY("n", "<S-A-n>", "<cmd>Gitsigns next_hunk<cr>", MAP_KEY_OPTS)
MAP_KEY("n", "<S-A-p>", "<cmd>Gitsigns prev_hunk<cr>", MAP_KEY_OPTS)
MAP_KEY("n", "<A-z>", "<cmd>Gitsigns reset_hunk<cr>", MAP_KEY_OPTS)
MAP_KEY("n", "<leader>ss", "<cmd>Gitsigns preview_hunk<cr>", MAP_KEY_OPTS)

-- Terminal
MAP_KEY("t", "<Esc>", "<C-\\><C-n>", MAP_KEY_OPTS)
MAP_KEY("t", "<A-y>", "<C-\\><C-n><cmd>ToggleTerm<cr>", MAP_KEY_OPTS)

vim.api.nvim_create_autocmd("FileType", {
    pattern = "json",
    callback = function()
        MAP_KEY("v", "<leader>f", "<cmd>CocCommand formatJson.selected --indent=4<cr>", { buffer = true })
        MAP_KEY("n", "<leader>fa", "<cmd>CocCommand formatJson --indent=4<cr>", { buffer = true })
        MAP_KEY("n", "<leader>f", "<Nop>")
    end
})

vim.api.nvim_create_autocmd("FileType", {
    pattern = "qf",
    callback = function()
        MAP_KEY("n", "<cr>", "<cr><cmd>copen<cr>", { buffer = true })
        MAP_KEY("n", "q", "<cmd>cclose<cr>", { buffer = true })
        MAP_KEY("n", "<A-CR>", "<cr><cmd>cclose<cr>", { buffer = true })
        MAP_KEY("n", "<esc>", "<cmd>cclose<cr>", { buffer = true })
        MAP_KEY("n", "x", "<cmd>.Reject<cr>", { buffer = true })
        MAP_KEY("v", "x", ":Reject<cr>", { buffer = true })
    end
})

-- LSP
MAP_KEY("n", "gr", telescope.lsp_references, MAP_KEY_OPTS)
MAP_KEY("n", "<A-p>", telescope.lsp_document_symbols, MAP_KEY_OPTS)
MAP_KEY("n", "<leader>gi", telescope.lsp_implementations, MAP_KEY_OPTS)

MAP_KEY("n", "gd", vim.lsp.buf.definition, MAP_KEY_OPTS)
MAP_KEY("n", "]]", vim.diagnostic.goto_next, MAP_KEY_OPTS)
MAP_KEY("n", "[[", vim.diagnostic.goto_prev, MAP_KEY_OPTS)
MAP_KEY("n", "<A-CR>", vim.lsp.buf.code_action, MAP_KEY_OPTS)
MAP_KEY("v", "<A-CR>", vim.lsp.buf.code_action, MAP_KEY_OPTS)
MAP_KEY("n", "<S-A-f>", vim.lsp.buf.format, MAP_KEY_OPTS)
MAP_KEY("v", "<S-A-f>", vim.lsp.buf.format, MAP_KEY_OPTS)
MAP_KEY("n", "<C-p>", vim.lsp.buf.signature_help, MAP_KEY_OPTS)
MAP_KEY("i", "<C-p>", vim.lsp.buf.signature_help, MAP_KEY_OPTS)
MAP_KEY("n", "<A-r>", vim.lsp.buf.rename, MAP_KEY_OPTS)
MAP_KEY("n", "<leader>ah", vim.lsp.buf.hover, MAP_KEY_OPTS)
MAP_KEY("n", "<leader>ls", "<cmd>LspStart<cr>", MAP_KEY_OPTS)
MAP_KEY("n", "<leader>lr", "<cmd>LspRestart<cr>", MAP_KEY_OPTS)

MAP_KEY("n", "-", require("oil").open, MAP_KEY_OPTS)
MAP_KEY("v", "<leader>fj", "!jq<cr>", MAP_KEY_OPTS)

-- Settings
MAP_KEY("n", "<leader>sw", "<cmd>set wrap!<cr>", MAP_KEY_OPTS)
MAP_KEY("n", "<leader>sp", "<cmd>silent! setlocal spell! spelloptions=camel spelllang=ru_yo,en_us<cr>", MAP_KEY_OPTS)

-- Alacritty specific mappings
MAP_KEY("n", "<C-Left>", "<C-w>h", MAP_KEY_OPTS)
MAP_KEY("n", "<C-Down>", "<C-w>j", MAP_KEY_OPTS)
MAP_KEY("n", "<C-Up>", "<C-w>k", MAP_KEY_OPTS)
MAP_KEY("n", "<C-Right>", "<C-w>l", MAP_KEY_OPTS)
MAP_KEY("n", "<C-A-Right>", "<cmd>vertical resize +5<cr>", MAP_KEY_OPTS)
MAP_KEY("n", "<C-A-Left>", "<cmd>vertical resize -5<cr>", MAP_KEY_OPTS)
MAP_KEY("n", "<C-A-Up>", "<cmd>horizontal resize +2<cr>", MAP_KEY_OPTS)
MAP_KEY("n", "<C-A-Down>", "<cmd>horizontal resize -2<cr>", MAP_KEY_OPTS)

MAP_KEY("n", "<leader>ip", "<cmd>echo expand('%:P')<cr>", MAP_KEY_OPTS)
MAP_KEY("n", "<leader>iP", "<cmd>echo expand('%:p')<cr>", MAP_KEY_OPTS)
