local opts = { noremap = true, silent = true }
-- Shorten function name
local map = vim.keymap.set

map("n", "<A-BS>", ":on<cr>", opts)
map("n", "<A-q>", ":Ex<cr>", opts)
map('n','<leader><leader>',':so<cr>', { silent = false })

-- Git
map('n','<A-C-a>',':!git add %<cr>', { silent = false })

-- Moving lines
map("n", "<S-A-j>", ":silent! m .+1<CR>==", opts)
map("n", "<S-A-k>", ":silent! m .-2<CR>==", opts)
map("v", "<S-A-j>", ":<C-u>silent! '<,'>m '>+1<CR>gv", opts)
map("v", "<S-A-k>", ":<C-u>silent! '<,'>m '<-2<CR>gv", opts)

-- Duplicate lines
map("n", "<S-A-d>", ":t.<cr>", opts)
map("v", '<S-A-d>', "y'>p'[V']", opts)

-- Lazy
map("n", "<leader>L", ":Lazy<cr>", opts)

-- Telescope
local ok, telescope = pcall(require, "telescope.builtin")
if ok then
    map("n", "<leader>ff", telescope.find_files, opts)
    map("n", "<leader>fg", telescope.live_grep, opts)
    map("n", "<A-e>", telescope.oldfiles, opts)
    map("n", "<leader>fh", telescope.help_tags, opts)
    map("n", "<leader>fc", telescope.command_history, opts)
    map("n", "<leader>fm", telescope.keymaps, opts)
    map("n", "<leader>fr", telescope.resume, opts)
    map("n", "<C-l>", telescope.git_status, opts)
end

-- Harpoon
map("n", "<leader>h", ':lua require("harpoon.ui").toggle_quick_menu()<cr>', opts)
map("n", "<leader>n", ':lua require("harpoon.mark").add_file()<cr>', opts)
map("n", "<A-a>", ':lua require("harpoon.ui").nav_file(1)<cr>', opts)
map("n", "<A-s>", ':lua require("harpoon.ui").nav_file(2)<cr>', opts)
map("n", "<A-d>", ':lua require("harpoon.ui").nav_file(3)<cr>', opts)
map("n", "<A-f>", ':lua require("harpoon.ui").nav_file(4)<cr>', opts)
map("n", "<A-g>", ':lua require("harpoon.ui").nav_file(5)<cr>', opts)
map("n", "<A-t>", ':lua require("harpoon.ui").nav_file(6)<cr>', opts)

-- Gitsings
map("n", "<C-A-d>", ":Gitsigns next_hunk<cr>", opts)
map("n", "<C-A-u>", ":Gitsigns prev_hunk<cr>", opts)
map("n", "<A-z>", ":Gitsigns reset_hunk<cr>", opts)
map("n", "<leader>s", ":Gitsigns preview_hunk<cr>", opts)

-- Terminal
map("t", "<Esc>", "<C-\\><C-n>", opts)
map("t", "<A-y>", "<C-\\><C-n>:ToggleTerm<cr>", opts)

--map('n','gD','<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
--map('n','gd',':Telescope lsp_definitions<cr>', opts)
--map("n", "gd", "<Plug>(coc-definition)", {silent = true})
--map("n", "gd", require("definition-or-references").definition_or_references, opts)
--map("n", "<S-A-f>", ":lua vim.lsp.buf.format()<cr>", {})
--map('n','gr',':Telescope lsp_references<cr>', opts)
--map('n','gs','<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
--map('n','gi',':Telescope lsp_implementations<cr>', opts)
--map('n','gt','<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
--map('n','<leader>gw','<cmd>lua vim.lsp.buf.document_symbol()<CR>', opts)
--map('n','<leader>gW','<cmd>lua vim.lsp.buf.workspace_symbol()<CR>', opts)
--map('n','<leader>ah','<cmd>lua vim.lsp.buf.hover()<CR>', opts)
--map('n','<A-CR>','<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
--map('n','<leader>ee','<cmd>lua vim.lsp.util.show_line_diagnostics()<CR>', opts)
--map('n','<leader>ar','<cmd>lua vim.lsp.buf.rename()<CR>', opts)
--map('n','<leader>ai','<cmd>lua vim.lsp.buf.incoming_calls()<CR>', opts)
--map('n','<leader>ao','<cmd>lua vim.lsp.buf.outgoing_calls()<CR>', opts)
--map('n','<leader>ls',':LspStart<cr>', opts)
--map('n','<leader>lr',':LspRestart<cr>', opts)
--map('n', '<A-r>', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)

