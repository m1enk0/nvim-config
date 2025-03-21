local map = vim.keymap.set
local opts = { noremap = true, silent = true }

local function getVisualSelection()
    vim.cmd('noau normal! "vy"')
    local text = vim.fn.getreg('v')
    text = string.gsub(text, "\n", "")
    if #text > 0 then return text else return '' end
end

local function mapTelescopeNV(shortcut, telescopeFun)
    local actions = require("telescope.actions")
    map("v", shortcut, function() telescopeFun({
        default_text = getVisualSelection(),
        attach_mappings  = function(_)
            actions.close:replace(function(prompt_bufnr)
                vim.api.nvim_buf_delete(prompt_bufnr, { force = true })
                vim.cmd("norm gv")
            end)
            return true
        end
    }) end, opts)
    map("n", shortcut, telescopeFun, opts)
end

local function current_dir()
    local dir = require("oil").get_current_dir()
    if dir == nil then return vim.fn.fnamemodify(vim.fn.bufname(), ":p:h") else return dir end
end

map("n", "<A-BS>", "<cmd>on<cr>", opts)

-- Split actions for undo
map("i", "<Cr>", "<Cr><C-g>u", opts)
map("i", "<Space>", "<Space><C-g>u", opts)

-- Git
map('n', '<A-C-a>', '<cmd>!git add %<cr>', { silent = false })
map('n', '<leader>kk', '<cmd>vertical Git<cr>', opts)
map('n', '<leader>kq', '<cmd>Git difftool<cr>', opts)

-- Moving lines
map("n", "<S-A-j>", "<cmd>silent! m .+1<CR>==", opts)
map("n", "<S-A-k>", "<cmd>silent! m .-2<CR>==", opts)
map("v", "<S-A-j>", ":<C-u>silent! '<,'>m '>+1<CR>gv", opts)
map("v", "<S-A-k>", ":<C-u>silent! '<,'>m '<-2<CR>gv", opts)

-- Duplicate lines
map("n", "<S-A-d>", "<cmd>t.<cr>", opts)
map("v", '<S-A-d>', "y'>p'[V']", opts)

-- Lazy
map("n", "<leader>L", "<cmd>Lazy<cr>", opts)

-- Window nav
map("n", "<A-C-j>", "<C-w>j", opts)
map("n", "<A-C-k>", "<C-w>k", opts)
map("n", "<A-C-l>", "<C-w>l", opts)
map("n", "<A-C-h>", "<C-w>h", opts)
map("n", "<A-C-i>", "<cmd>vertical resize +5<cr>", opts)
map("n", "<A-C-o>", "<cmd>vertical resize -5<cr>", opts)
map("n", "<A-C-e>", "<cmd>horizontal resize +2<cr>", opts)
map("n", "<A-C-w>", "<cmd>horizontal resize -2<cr>", opts)

-- Qf nav
map("n", "<S-A-o>", "<cmd>cnext<cr>", opts)
map("n", "<S-A-u>", "<cmd>cprev<cr>", opts)

-- Tab nav 
map("n", "<S-A-h>", "<cmd>tabprev<cr>", opts)
map("n", "<S-A-l>", "<cmd>tabnext<cr>", opts)
map("n", "<leader>tq", "<cmd>tabclose<cr>", opts)
map("n", "<leader>tn", "<cmd>execute 'tabedit +'.line('.').' %'<cr>", opts)
map("n", "<leader>to", "<cmd>tabonly<cr>", opts)
map("n", "<leader>ts", "<cmd>vs | Scratch %<cr>", opts)

-- Telescope
local ok, telescope = pcall(require, "telescope.builtin")
if ok then
    mapTelescopeNV("<leader>ff", telescope.find_files)
    mapTelescopeNV("<leader>fg", telescope.live_grep)
    mapTelescopeNV("<leader>fh", telescope.help_tags)
    mapTelescopeNV("<leader>fp", telescope.pickers)
    map("n", "<A-e>", telescope.oldfiles, opts)
    map("n", "<leader>fr", telescope.resume, opts)
    map("n", "<C-l>", telescope.git_status, opts)
    map("n", "<leader>ks", telescope.git_stash, opts)
    map("n", "<leader>kb", telescope.git_branches, opts)
    map("n", "<leader>fw", "<cmd>Telescope current_buffer_fuzzy_find fuzzy=false case_mode=ignore_case<cr>", opts)

    map("n", "<leader>FF", function() telescope.find_files({ cwd = current_dir() }) end, opts)
    map("n", "<leader>FG", function() telescope.live_grep({ cwd = current_dir() }) end, opts)
end

-- Harpoon
map("n", "<A-h>", '<cmd>lua require("harpoon.ui").toggle_quick_menu()<cr>', opts)
map("n", "<A-n>", '<cmd>lua require("harpoon.mark").add_file()<cr>', opts)
map("n", "<A-a>", '<cmd>lua require("harpoon.ui").nav_file(1)<cr>', opts)
map("n", "<A-s>", '<cmd>lua require("harpoon.ui").nav_file(2)<cr>', opts)
map("n", "<A-d>", '<cmd>lua require("harpoon.ui").nav_file(3)<cr>', opts)
map("n", "<A-f>", '<cmd>lua require("harpoon.ui").nav_file(4)<cr>', opts)
map("n", "<A-g>", '<cmd>lua require("harpoon.ui").nav_file(5)<cr>', opts)
map("n", "<A-t>", '<cmd>lua require("harpoon.ui").nav_file(6)<cr>', opts)

-- Gitsings
map("n", "<C-A-d>", "<cmd>Gitsigns next_hunk<cr>", opts)
map("n", "<C-A-u>", "<cmd>Gitsigns prev_hunk<cr>", opts)
map("n", "<A-z>", "<cmd>Gitsigns reset_hunk<cr>", opts)
map("n", "<leader>s", "<cmd>Gitsigns preview_hunk<cr>", opts)

-- Terminal
map("t", "<Esc>", "<C-\\><C-n>", opts)
map("t", "<A-y>", "<C-\\><C-n><cmd>ToggleTerm<cr>", opts)

vim.api.nvim_create_autocmd("FileType", {
    pattern = "json",
    callback = function()
        map("v", "<leader>f", "<cmd>CocCommand formatJson.selected --indent=4<cr>", { buffer = true })
        map("n", "<leader>fa", "<cmd>CocCommand formatJson --indent=4<cr>", { buffer = true })
        map("n", "<leader>f", "<Nop>")
    end
})

vim.api.nvim_create_autocmd("FileType", {
    pattern = "qf",
    callback = function()
        map("n", "<cr>", "<cr><cmd>copen<cr>", { buffer = true })
        map("n", "q", "<cmd>cclose<cr>", { buffer = true })
        map("n", "<A-CR>", "<cr><cmd>cclose<cr>", { buffer = true })
        map("n", "<esc>", "<cmd>cclose<cr>", { buffer = true })
        map("n", "x", "<cmd>.Reject<cr>", { buffer = true })
        map("v", "x", ":Reject<cr>", { buffer = true })
    end
})

-- LSP
map("n", "gr", telescope.lsp_references, opts)
map("n", "<A-p>", telescope.lsp_document_symbols, opts)
map("n", "<leader>gi", telescope.lsp_implementations, opts)

map("n", "gd", vim.lsp.buf.definition, opts)
map("n", "]]", vim.diagnostic.goto_next, opts)
map("n", "[[", vim.diagnostic.goto_prev, opts)
map("n", "<A-CR>", vim.lsp.buf.code_action, opts)
map("v", "<A-CR>", vim.lsp.buf.code_action, opts)
map("n", "<S-A-f>", vim.lsp.buf.format, opts)
map("v", "<S-A-f>", vim.lsp.buf.format, opts)
map("n", "<C-p>", vim.lsp.buf.signature_help, opts)
map("i", "<C-p>", vim.lsp.buf.signature_help, opts)
map("n", "<A-r>", vim.lsp.buf.rename, opts)
map("n", "<leader>ah", vim.lsp.buf.hover, opts)
map("n", "<leader>ls", "<cmd>LspStart<cr>", opts)
map("n", "<leader>lr", "<cmd>LspRestart<cr>", opts)

map("n", "-", require("oil").open, opts)