function CompareWithClipboard()
    vim.cmd('tabnew')
    local selection_buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_lines(selection_buf, 0, -1, false, vim.split(vim.fn.getreg('"'), "\n"))
    vim.api.nvim_set_current_buf(selection_buf)
    vim.cmd('vsplit')
    local clipboard_buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_lines(clipboard_buf, 0, -1, false, vim.split(vim.fn.getreg('+'), "\n"))
    vim.api.nvim_set_current_buf(clipboard_buf)
    vim.cmd('windo diffthis')
end

vim.api.nvim_create_user_command('CompareClip', CompareWithClipboard, {})

MAP_KEY('v', '<leader>lc', 'y:CompareClip<CR>', MAP_KEY_OPTS)
