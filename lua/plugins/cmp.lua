local function no_kind(entry, vim_item)
    vim_item.kind = ""
    return vim_item
end

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
            })
        end
    },
    {
        'hrsh7th/cmp-nvim-lsp', -- LSP source for nvim-cmp,
        event = "VeryLazy",
        config = function()
            require("cmp_nvim_lsp").default_capabilities()
        end
    },
    {
        "neovim/nvim-lspconfig",
        event = "VeryLazy",
        config = function()
            local lspconfig = require 'lspconfig'
            -- local util = require 'lspconfig/util'
            local capabilities = require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities())
            lspconfig.util.default_config = vim.tbl_deep_extend("force", lspconfig.util.default_config, {
                capabilities = capabilities
            })

            lspconfig.thriftls.setup {}
            lspconfig.lua_ls.setup {}
            lspconfig.jdtls.setup {
                autostart = false
            }
            lspconfig.gopls.setup {
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
                        }
                    }
                }
            }
            lspconfig.golangci_lint_ls.setup {
                filetypes = { 'go', 'gomod' }
            }
        end
    },
    {
        "hrsh7th/nvim-cmp",
        event = "VeryLazy",
        dependencies = {
            "hrsh7th/cmp-nvim-lua",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
            "hrsh7th/cmp-cmdline",
            "saadparwaiz1/cmp_luasnip",
            "onsails/lspkind.nvim"
        },
        config = function()
            local cmp = require('cmp')
            local lspkind = require('lspkind')
            cmp.setup({
                formatting = {
                    fields = { "kind", "abbr", "menu" },
                    format = function(entry, vim_item)
                        local kind = vim_item.kind
                        vim_item.kind = lspkind.presets.default[vim_item.kind]
                        -- vim_item.abbr = "" .. vim_item.abbr
                        local item = entry:get_completion_item()
                        if item.detail then vim_item.menu = item.detail else vim_item.menu = kind end
                        return vim_item
                    end
                },
                window = {
                    documentation = false,
                    completion = {
                        col_offset = -2,
                    }
                },
                completion = {
                    completeopt = 'menu,menuone,noinsert',
                    keyword_length = 1,
                    debounce = 7
                },
                performance = {
                    throttle_time = 20, -- Lower throttle time
                    debounce = 7, -- Lower debounce
                    fetching_timeout = 200, -- Timeout for fetching
                },
                preselect = false,
                sorting = {
                    comparators = {
                        cmp.config.compare.offset,
                        cmp.config.compare.exact,
                        cmp.config.compare.score,
                        cmp.config.compare.recently_used,
                        cmp.config.compare.kind
                    },
                },
                snippet = {
                    expand = function(args)
                        require('luasnip').lsp_expand(args.body)
                    end
                },
                mapping = cmp.mapping.preset.insert({
                    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
                    ['<C-f>'] = cmp.mapping.scroll_docs(4),
                    ['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),
                    ['<C-j>'] = cmp.mapping(cmp.mapping.select_next_item(), { "c" }),
                    ['<C-k>'] = cmp.mapping(cmp.mapping.select_prev_item(), { "c" }),
                    ['<Tab>'] = cmp.mapping.confirm { behavior = cmp.ConfirmBehavior.Replace, select = true },
                    ['<C-e>'] = cmp.mapping.abort(),
                    ['<CR>'] = cmp.mapping(function(fallback)
                        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<C-g>u', true, true, true), 'n', true)
                        cmp.mapping.confirm({ select = true })(fallback)
                    end, { 'i', 's' })
                }),
                sources = cmp.config.sources({
                    { name = 'nvim_lsp' }, { name = 'luasnip' }
                }, {
                    { name = 'buffer' }, { name = 'path' }
                })
            })
            cmp.setup.cmdline({ '/', '?' }, {
                completion = { completeopt = 'menu,menuone,noselect' },
                formatting = { format = no_kind },
                mapping = cmp.mapping.preset.cmdline(),
                sources = {
                    { name = 'buffer' }
                }
            })
            cmp.setup.cmdline(':', {
                completion = { completeopt = 'menu,menuone,noselect' },
                formatting = { format = no_kind },
                mapping = cmp.mapping.preset.cmdline(),
                sources = cmp.config.sources({
                    { name = 'path' }
                }, {
                    { name = 'cmdline' }
                })
            })
        end
    }
}