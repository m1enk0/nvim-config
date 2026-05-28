local M = {}

local config = {
    filename = '.nvim_settings.lua',
}

project_settings = {
    telescope = {
        append_file_ignore_patterns = {}
    },
    lsp = {
        lua_ls = {},
        gopls = {},
        jdtls = {
            offline = false
        },
        yamlls = {},
        jsonls = {},
        clangd = {},
        rust_analyzer = {},
    }
}

function M.load_settings()
    pcall(dofile, vim.fn.getcwd() .. "/" .. config.filename)
end

return M
