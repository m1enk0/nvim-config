return {
    {
        "williamboman/mason.nvim",
        event = "BufEnter",
        config = function()
            require("mason").setup({
                PATH = "prepend"
            })
        end
    },
    {
        "neovim/nvim-lspconfig",
        event = "VeryLazy",
        config = function()
            local capabilities = require('blink.cmp').get_lsp_capabilities(vim.lsp.protocol.make_client_capabilities())
            local config_setup_map = {
                lua_ls = {},
                gopls = {
                    root_dir = vim.fs.root(0, { "go.work", "go.mod", ".git" }) or vim.fn.getcwd(),
                    cmd = { "gopls" },
                    filetypes = { "go", "gomod", "gowork" },
                    settings = {
                        gopls = {
                            codelenses = {
                                gc_details = true,
                            },
                            usePlaceholders = false,
                            staticcheck = true,
                            completeUnimported = true,
                            analyses = {
                                nilness = true,
                                unusedparams = true,
                                unusedvariable = true,
                                unusedwrite = true,
                                useany = true,
                                shadow = true,
                                ST1000 = false, -- package comment requirement
                            }
                        }
                    }
                },
                yamlls = {},
                jsonls = {},
                clangd = {
                    cmd = {
                        'clangd',
                        '--background-index',
                        '--header-insertion=iwyu',
                        '--completion-style=detailed',
                        '--function-arg-placeholders=0',
                        '--header-insertion=iwyu',
                        '--all-scopes-completion'
                    },
                },
                rust_analyzer = {
                    settings = {
                        ['rust-analyzer'] = {
                            cargo = { 
                                autoreload = true,
                                allFeatures = true
                            },
                            files = { watcher = "client" },
                        },
                    },
                }
            }
            -- Apply common capabilities to all servers
            for _, config in pairs(config_setup_map) do config.capabilities = capabilities end

            vim.iter(config_setup_map)
                :each(function(key, value) 
                    if project_settings.lsp[key] and project_settings.lsp[key].enabled then
                        vim.lsp.config(key, value) 
                        vim.lsp.enable(key)
                    end
                end)
        end
    }
}
