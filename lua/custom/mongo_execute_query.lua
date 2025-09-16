function MongoExecuteQuery()
    local main_query = vim.api.nvim_buf_get_lines(vim.api.nvim_get_current_buf(), 0, 1, false)[1]
    local param = vim.fn.getreg('"'):gsub('[\r\n]', ' '):gsub('\'', '"')

    if #param == 0 then
        vim.notify("No item selected", vim.log.levels.ERROR)
        return
    end

    local collection_name = param:match([[db[%s]*%.%s*([%w$_-]+)]]) or param:match([[db[%s]*%[%s*['"]([^'"]+)['"]%s*]])

    local cmd = string.format(main_query,  param)
    local output = ExecDependingOnOS(cmd)
    local output_lines = vim.split(cmd .. "\n\n" .. output, '\n')
    local scratch_buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_option(scratch_buf, 'filetype', 'js')
    vim.api.nvim_buf_set_lines(scratch_buf, 0, -1, false, output_lines)
    vim.cmd('vsplit')
    vim.api.nvim_set_current_buf(scratch_buf)
    vim.b.executed_query_format = main_query
    vim.b.executed_query = cmd
    vim.b.collection_name = collection_name
    MAP_KEY('n', '<leader>rr', '<cmd>ReexecuteQuery<cr>', { buffer = true })
    MAP_KEY('n', '<leader>w', function ()
        MongoYankDocToReplace()
        MongoReplaceDoc()
    end, { buffer = true })
end

vim.api.nvim_create_user_command('MongoExecuteQuery', MongoExecuteQuery, {})

MAP_KEY('v', '<leader>mq', 'y:MongoExecuteQuery<CR>', MAP_KEY_OPTS)
MAP_KEY('n', '<leader>mq', 'vipy:MongoExecuteQuery<CR>', MAP_KEY_OPTS)
