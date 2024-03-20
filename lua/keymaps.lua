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
    map("n", "<leader>fw", ":Telescope current_buffer_fuzzy_find fuzzy=false case_mode=ignore_case<cr>", opts)
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

vim.api.nvim_create_autocmd("FileType", {
    pattern = "json",
    callback = function()
	map("v", "<leader>f", ":CocCommand formatJson.selected --indent=4<cr>", { buffer = true})
	map("n", "<leader>fa", ":CocCommand formatJson --indent=4<cr>", { buffer = true })
	map("n", "<leader>f", "<Nop>")
    end,
})
