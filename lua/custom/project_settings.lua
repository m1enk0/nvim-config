local M = {}

local config = {
    filename = '.nvim_settings.lua',
}

local project_settings = {}
local loaded = false

function M.get_settings()
    if loaded then
        return project_settings
    end
    loaded = true
    _, project_settings = pcall(dofile, vim.fn.getcwd() .. "/" .. config.filename)

    return project_settings
end

return M
