local opts = { noremap = true, silent = true }
local term_opts = { silent = true }
-- Shorten function name
local map = vim.keymap.set

map("n", "<A-BS>", ":on<cr>", opts)
map("n", "<A-q>", ":Ex<cr>", opts)

-- Lazy
map("n", "<leader>L", ":Lazy<cr>", opts)

-- Moving lines
map("n", "<S-A-j>", ":silent! m .+1<CR>==", opts)
map("n", "<S-A-k>", ":silent! m .-2<CR>==", opts)
map("v", "<S-A-j>", ":m '>+1<CR>gv=gv", opts)
map("v", "<S-A-k>", ":m '<-2<CR>gv=gv", opts)

-- Duplicate lines
map("n", "<S-A-d>", ":t.<cr>", opts)
--map('v', '<S-A-d>', ':t.<cr>', opts)

-- Telescope
local telescope = require("telescope.builtin")
map("n", "<leader>ff", telescope.find_files, opts)
map("n", "<leader>fg", telescope.live_grep, opts)
map("n", "<leader>fb", telescope.buffers, opts)
map("n", "<leader>fh", telescope.help_tags, opts)
map("n", "<leader>fc", telescope.command_history, opts)
map("n", "<leader>fm", telescope.keymaps, opts)
-- map('n', '<A-e>', ':lua require("telescope").extensions.recent_files.pick()<cr>', opts)

-- Neotree
--map('n', '<A-q>', ':NvimTreeOpen<cr>', opts)

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

-- null-ls
map("n", "<leader>lf", ":lua vim.lsp.buf.format()<cr>", opts)

