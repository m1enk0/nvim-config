function ExecuteParamQuery()
    local main_query = vim.api.nvim_buf_get_lines(vim.api.nvim_get_current_buf(), 0, 1, false)[1]
    local param = vim.fn.getreg('"'):gsub('[\r\n]', ' ')

    if #param == 0 then
        vim.notify("No item selected", vim.log.levels.ERROR)
        return
    end

    local cmd = string.format(main_query,  param)
    local output = vim.fn.system(cmd)
    local output_lines = vim.split(cmd .. "\n\n" .. output, '\n')
    local scratch_buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_option(scratch_buf, 'filetype', 'js')
    vim.api.nvim_buf_set_lines(scratch_buf, 0, -1, false, output_lines)
    vim.cmd('vsplit')
    vim.api.nvim_set_current_buf(scratch_buf)
end

vim.api.nvim_create_user_command('ExecuteParamQuery', ExecuteParamQuery, {})

MAP_KEY('v', '<leader>mq', 'y:ExecuteParamQuery<CR>', MAP_KEY_OPTS)
