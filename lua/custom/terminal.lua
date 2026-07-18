local M = {}

local tabterms = {}
local splitterms = {}

function M.open_tabterm(id, in_tab)
    local t = tabterms[id]

    if t and vim.api.nvim_buf_is_valid(t.buf) then
        if not t.tab or not vim.api.nvim_tabpage_is_valid(t.tab) then
            if in_tab then
                vim.cmd("tab split")
            end
            vim.cmd("buffer " .. t.buf)
            tabterms[id].tab = vim.api.nvim_get_current_tabpage()
            return
        end
        vim.api.nvim_set_current_tabpage(t.tab)
        vim.api.nvim_set_current_buf(t.buf)
        return
    end
    vim.cmd("tab split | term")
    vim.api.nvim_buf_set_name(0, "Tabterm " .. id)
    -- vim.cmd("startinsert")
    tabterms[id] = {
        buf = vim.api.nvim_get_current_buf(),
        tab = vim.api.nvim_get_current_tabpage(),
    }
end

function M.toggle_splitterm(id)
    local term = splitterms[id] or {}
    local curr_tab = vim.api.nvim_get_current_tabpage()
    local win = (term.tabs or {})[curr_tab]

    if win and vim.api.nvim_win_is_valid(win) and #vim.api.nvim_tabpage_list_wins(curr_tab) > 1 then
        if win == vim.api.nvim_get_current_win() then vim.api.nvim_win_close(win, false) else vim.api.nvim_set_current_win(win) end
        return
    end

    if not term.tabs then term.tabs = {} end
    vim.cmd("botright split")
    if term.buf and vim.api.nvim_buf_is_valid(term.buf) then
        vim.api.nvim_set_current_buf(term.buf)
    else
        vim.cmd("term")
        vim.cmd("startinsert")
        term.buf = vim.api.nvim_get_current_buf()
    end
    term.tabs[curr_tab] = vim.api.nvim_get_current_win()
    splitterms[id] = term
end

function M.detach_splitterm_from_win()
    local buf = vim.api.nvim_get_current_buf()
    -- local name = vim.api.nvim_buf_get_name(buf)
    local found = vim.iter(splitterms):find(function(v) return v and v.buf == buf end)
    if found then
        vim.cmd("term")
        found.buf = vim.api.nvim_get_current_buf()
    end
end

return M
