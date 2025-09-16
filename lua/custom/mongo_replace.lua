function MongoReplaceDoc()
    local doc = vim.fn.getreg('"'):gsub('[\r\n]', ' '):gsub('\'', '"')

    local function extract_id(text)
        local id = text:match('%s*_id:%s*([^,]+)')
        return id and id:gsub('^%s*(.-)%s*$', '%1') or nil
    end
    local doc_id = extract_id(doc)

    local replace_query = string.format('db["%s"].replaceOne({_id: %s}, %s)', vim.b.collection_name, doc_id, doc)
    local cmd = string.format(vim.b.executed_query_format, replace_query)
    local output = ExecDependingOnOS(cmd)
    vim.notify("Replacing doc with id = " .. doc_id .. "; collection name = " .. vim.b.collection_name .. "\n" .. output)
end

function MongoYankDocToReplace()
    local found_line = vim.fn.search('_id', 'bcnW')
    vim.fn.cursor(found_line, 1)
    vim.cmd('norm! ya{')
end

vim.api.nvim_create_user_command('MongoReplaceDoc', MongoReplaceDoc, {})

MAP_KEY('v', '<leader>mr', 'y:MongoReplaceDoc<CR>', MAP_KEY_OPTS)
