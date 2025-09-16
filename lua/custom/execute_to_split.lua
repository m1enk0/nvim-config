function ExecDependingOnOS(cmd)
    local is_windows = vim.fn.has('win32') == 1 or vim.fn.has('win64') == 1
    local output
    if is_windows then
        output = vim.fn.system({ 'pwsh', '-NoProfile', '-Command', cmd }):gsub('\r', '\n')
    else
        output = vim.fn.system(cmd)
    end
    output = output:gsub('\x1b%[[%d;]*[a-zA-Z]', '') -- Remove ANSI escape sequences (colors, etc.)
    return output
end

function ExecuteToSplit()
    local cmd = vim.fn.getreg('"'):gsub('[\r\n]', ' ')
    local output = ExecDependingOnOS(cmd)
    local scratch_buf = vim.api.nvim_create_buf(false, true)
    local lines = vim.split(cmd .. "\n\n" .. output, '\n')
    vim.api.nvim_buf_set_lines(scratch_buf, 0, -1, false, lines)
    vim.cmd('vsplit')
    vim.api.nvim_set_current_buf(scratch_buf)
    vim.b.executed_query = cmd
    MAP_KEY('n', '<leader>rr', '<cmd>ReexecuteQuery<cr>', { buffer = true })
end

function ReexecuteQuery()
    local current_buf = vim.api.nvim_get_current_buf()
    local cmd = vim.b.executed_query
    local output = ExecDependingOnOS(cmd)
    local output_lines = vim.split(cmd .. "\n\n" .. output, '\n')
    vim.api.nvim_buf_set_lines(current_buf, 0, -1, false, output_lines)
end

vim.api.nvim_create_user_command('ReexecuteQuery', ReexecuteQuery, {})
vim.api.nvim_create_user_command('ExecuteToSplit', ExecuteToSplit, {})

MAP_KEY('v', '<leader>ee', 'y:ExecuteToSplit<CR>', MAP_KEY_OPTS)
MAP_KEY('n', '<leader>ee', 'vipy:ExecuteToSplit<CR>', MAP_KEY_OPTS)
