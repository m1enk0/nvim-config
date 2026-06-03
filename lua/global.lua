local terminals = {}

global = {
    map_key = vim.keymap.set,
    map_key_opts = { noremap = true, silent = true },

    execute_to_split = function(cmd, filetype)
        local output = global.exec_depending_on_os(cmd)
        local scratch_buf = vim.api.nvim_create_buf(false, true)
        local lines = vim.split(cmd .. "\n\n" .. output, '\n')
        vim.api.nvim_buf_set_option(scratch_buf, 'filetype', filetype)
        vim.api.nvim_buf_set_lines(scratch_buf, 0, -1, false, lines)
        vim.cmd('vsplit')
        vim.api.nvim_set_current_buf(scratch_buf)
        vim.b.executed_query = cmd
        global.map_key('n', '<leader>rr', '<cmd>ReexecuteQuery<cr>', { buffer = true })
    end,
    execute_yanked_to_split = function () 
        local cmd_lines = vim.split(vim.fn.getreg('"'), '[\r\n]')
        local cleaned_lines = {}
        for _, line in pairs(cmd_lines) do
            if not line:match('^%s*#') then 
                table.insert(cleaned_lines, line)
            end
        end
        global.execute_to_split(table.concat(cleaned_lines, ' '), 'json')
    end,
    reexecute_query = function()
        local current_buf = vim.api.nvim_get_current_buf()
        local cmd = vim.b.executed_query
        local output = global.exec_depending_on_os(cmd)
        local output_lines = vim.split(cmd .. "\n\n" .. output, '\n')
        vim.api.nvim_buf_set_lines(current_buf, 0, -1, false, output_lines)
    end,
    exec_depending_on_os = function(cmd)
        local is_windows = vim.fn.has('win32') == 1 or vim.fn.has('win64') == 1
        local output
        if is_windows then
            output = vim.fn.system({ 'pwsh', '-NoProfile', '-Command', cmd }):gsub('\r', '\n')
        else
            output = vim.fn.system(cmd)
        end
        output = output:gsub('\x1b%[[%d;]*[a-zA-Z]', '') -- Remove ANSI escape sequences (colors, etc.)
        return output
    end,
    jump_to_main = function()
        if vim.g.main_tab and vim.api.nvim_tabpage_is_valid(vim.g.main_tab) then
            vim.api.nvim_set_current_tabpage(vim.g.main_tab)
        end
        if vim.g.main_win and vim.api.nvim_win_is_valid(vim.g.main_win) then
            vim.api.nvim_set_current_win(vim.g.main_win)
        end
    end,
    open_term_tab = function(name, tab)
        local t = terminals[name]

        if t and vim.api.nvim_buf_is_valid(t.buf) then
            if not t.tab or not vim.api.nvim_tabpage_is_valid(t.tab) then
                if tab then
                    vim.cmd("tab split")
                end
                vim.cmd("buffer " .. t.buf)
                terminals[name].tab = vim.api.nvim_get_current_tabpage()
                return
            end
            vim.api.nvim_set_current_tabpage(t.tab)
            vim.api.nvim_set_current_buf(t.buf)
            return
        end
        vim.cmd("tab split | term")
        vim.api.nvim_buf_set_name(0, name)
        -- vim.cmd("startinsert")
        terminals[name] = {
            buf = vim.api.nvim_get_current_buf(),
            tab = vim.api.nvim_get_current_tabpage(),
        }
    end,
    get_visual_selection = function()
        vim.cmd('noau normal! "vy"')
        local text = vim.fn.getreg('v')
        text = string.gsub(text, "\n", "")
        if #text > 0 then return text else return '' end
    end
}
