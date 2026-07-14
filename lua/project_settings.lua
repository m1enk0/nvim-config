local M = {}

local config = {
    filename = '.nvim_settings.lua',
}

project_settings = {
    telescope = {
        append_file_ignore_patterns = {}
    },
    lsp = {
        enable = {},
        jdtls = {
            offline = false
        },
    }
}

function M.load_settings()
    pcall(dofile, vim.fn.getcwd() .. "/" .. config.filename)
end

return M
