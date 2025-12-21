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
            require("mason-lspconfig").setup({})
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
                    filetypes = { "go", "gomod", "gowork", "gotmpl" },
                    root_dir = lspconfig.util.root_pattern("go.work", "go.mod", ".git"),
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
                -- yamlls = {},
                -- jsonls = {}
            }

            local settings = require("custom.project_settings").get_settings()
            local disabled = {}
            if settings and settings.lsp and settings.lsp.disable then
                disabled = settings.lsp.disable
            end

            vim.iter(config_setup_map)
                :filter(function(key, _) return not vim.list_contains(disabled, key) end)
                :each(function(key, value) lspconfig[key].setup(value) end)
        end
    }
}
