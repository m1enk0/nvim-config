MAP_KEY = vim.keymap.set
MAP_KEY_OPTS = { noremap = true, silent = true }

MAP_KEY("n", "<A-BS>", "<cmd>on<cr>", MAP_KEY_OPTS)

-- Split actions for undo
MAP_KEY("i", "<Cr>", "<Cr><C-g>u", MAP_KEY_OPTS)
MAP_KEY("i", "<Space>", "<Space><C-g>u", MAP_KEY_OPTS)

-- Git
MAP_KEY('n', '<A-C-a>', '<cmd>!git add %<cr>', { silent = false })
MAP_KEY('n', '<S-A-a>', '<cmd>!git add %<cr>', { silent = false })

-- Moving lines
MAP_KEY("n", "<S-A-j>", "<cmd>silent! m .+1<CR>==", MAP_KEY_OPTS)
MAP_KEY("n", "<S-A-k>", "<cmd>silent! m .-2<CR>==", MAP_KEY_OPTS)
MAP_KEY("v", "<S-A-j>", ":<C-u>silent! '<,'>m '>+1<CR>gv", MAP_KEY_OPTS)
MAP_KEY("v", "<S-A-k>", ":<C-u>silent! '<,'>m '<-2<CR>gv", MAP_KEY_OPTS)

-- Duplicate lines
MAP_KEY("n", "<S-A-d>", "<cmd>t.<cr>", MAP_KEY_OPTS)
-- MAP_KEY("v", '<S-A-d>', "y'>p'[V']", MAP_KEY_OPTS)
MAP_KEY("v", '<S-A-d>', "y'>pgv", MAP_KEY_OPTS)

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
MAP_KEY("n", "<S-A-p>", "<cmd>cnext<cr>", MAP_KEY_OPTS)
MAP_KEY("n", "<S-A-u>", "<cmd>cprev<cr>", MAP_KEY_OPTS)

-- Tab nav
MAP_KEY("n", "<S-A-h>", "<cmd>tabprev<cr>", MAP_KEY_OPTS)
MAP_KEY("n", "<S-A-l>", "<cmd>tabnext<cr>", MAP_KEY_OPTS)
MAP_KEY("n", "<leader>tq", "<cmd>tabclose<cr>", MAP_KEY_OPTS)
MAP_KEY("n", "<leader>tn", "<cmd>tab split<cr>", MAP_KEY_OPTS)
MAP_KEY("n", "<leader>tN", "<C-w>T", MAP_KEY_OPTS)
MAP_KEY("n", "<leader>to", "<cmd>tabonly<cr>", MAP_KEY_OPTS)
MAP_KEY("n", "<leader>ts", "<cmd>vs | Scratch %<cr>", MAP_KEY_OPTS)
MAP_KEY("n", "<leader>tS", "<cmd>vs | Scratch %<cr><C-w>T", MAP_KEY_OPTS)

MAP_KEY("n", "<leader>ff", ":e **/**<Left>")
MAP_KEY("n", "<leader>fg", ":vimgrep // **<Left><Left><Left><Left>")
MAP_KEY("n", "<A-e>", "<cmd>buffers<cr>:buffer ")

MAP_KEY("n", "<A-f>", '<cmd>silent! close<enter>', MAP_KEY_OPTS)

MAP_KEY("t", "<Esc>", "<C-\\><C-n>", MAP_KEY_OPTS)

vim.api.nvim_create_autocmd("FileType", {
    pattern = "qf",
    callback = function()
        MAP_KEY("n", "<cr>", "<cr><cmd>copen<cr>", { buffer = true })
        MAP_KEY("n", "q", "<cmd>cclose<cr>", { buffer = true })
        MAP_KEY("n", "<A-CR>", "<cr><cmd>cclose<cr>", { buffer = true })
        MAP_KEY("n", "<esc>", "<cmd>cclose<cr>", { buffer = true })
    end
})

MAP_KEY("n", "-", function()
    local filename = vim.fn.expand('%:t')
    vim.cmd('Explore')
    vim.fn.search('^\\V' .. filename)
    vim.cmd('noh')
end, MAP_KEY_OPTS)
vim.api.nvim_create_autocmd("FileType", {
    pattern = "netrw",
    callback = function()
        MAP_KEY("n", "<C-c>", "<cmd>bd<cr>", { buffer = true })
    end
})

MAP_KEY("v", "<leader>fj", ":!jq .<cr>", MAP_KEY_OPTS)

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

MAP_KEY("n", "<leader>ip", "<cmd>echon expand('%:P')<cr>", MAP_KEY_OPTS)
MAP_KEY("n", "<leader>iP", "<cmd>echon expand('%:p')<cr>", MAP_KEY_OPTS)

MAP_KEY("n", "<S-A-o>", "<cmd>copen<cr>", MAP_KEY_OPTS)
