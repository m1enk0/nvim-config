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
        "williamboman/mason-lspconfig.nvim",
        event = "VeryLazy",
        config = function()
            require("mason-lspconfig").setup({
                automatic_enable = false
            })
        end
    },
    {
        "neovim/nvim-lspconfig",
        event = "VeryLazy",
        config = function()
            local lspconfig = require('lspconfig')

            local capabilities = require('blink.cmp').get_lsp_capabilities(vim.lsp.protocol.make_client_capabilities())
            lspconfig.util.default_config = vim.tbl_deep_extend("force", lspconfig.util.default_config, {
                capabilities = capabilities,
            })

            local config_setup_map = {
                lua_ls = {},
                gopls = {
                    cmd = { "gopls" },
                    filetypes = { "go", "gomod", "gowork" },
                    settings = {
                        gopls = {
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
