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
        'hrsh7th/cmp-nvim-lsp', -- LSP source for nvim-cmp,
        event = "VeryLazy",
        config = function()
            require("cmp_nvim_lsp").default_capabilities()
        end
    },
    {
        "neovim/nvim-lspconfig",
        version = "v1.8.0", -- above versions require nvim v10+
        event = "VeryLazy",
        config = function()
            local lspconfig = require 'lspconfig'
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
            lspconfig.yamlls.setup {}
            lspconfig.jsonls.setup {}
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
            "onsails/lspkind.nvim",
            "lukas-reineke/cmp-under-comparator",
        },
        config = function()
            local cmp = require('cmp')
            local lspkind = require('lspkind')
            cmp.setup({
                formatting = {
                    fields = { "kind", "abbr", "menu" },
                    format = function(entry, vim_item)
                        local kind = vim_item.kind
                        vim_item.kind = lspkind.presets.codicons[vim_item.kind]
                        local item = entry:get_completion_item()

                        local menu;
                        if item.detail then
                            if vim_item.menu and vim_item.menu:len() >= 1 then
                                menu = vim_item.menu .. " " .. item.detail
                            else
                                menu = item.detail
                            end
                        else
                            menu = kind
                        end
                        local menu_lim = 70
                        local menu_len = menu:len()
                        if menu_len > menu_lim then
                            menu = menu:sub(1, menu_lim / 2) .. "••" .. menu:sub(menu_len - (menu_lim / 2), menu_len)
                        end

                        vim_item.menu = menu
                        return vim_item
                    end
                },
                window = {
                    documentation = false,
                    completion = cmp.config.window.bordered({
                        border = "rounded",
                        winhighlight = "Normal:Pmenu,FloatBorder:Pmenu,CursorLine:PmenuSel,Search:None",
                        col_offset = -3
                    })
                },
                completion = {
                    completeopt = 'menu,menuone,noinsert',
                    debounce = 1,
                },
                performance = {
                    throttle_time = 15,
                    debounce = 1,
                    fetching_timeout = 200,
                },
                preselect = false,
                sorting = {
                    priority_weight = 1.0,
                    comparators = {
                        -- compare.score_offset, -- not good at all
                        cmp.config.compare.offset,
                        cmp.config.compare.score, -- based on :  score = score + ((#sources - (source_index - 1)) * sorting.priority_weight)
                        cmp.config.compare.recently_used,
                        require "cmp-under-comparator".under,
                        cmp.config.compare.locality,
                        cmp.config.compare.exact,
                        cmp.config.compare.kind,
                        cmp.config.compare.length,
                        cmp.config.compare.order,
                        cmp.config.compare.scope,
                        -- compare.sort_text,
                    },
                },
                snippet = {
                    expand = function(args)
                        require('luasnip').lsp_expand(args.body)
                    end
                },
                mapping = {
                    ['<Down>'] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),
                    ['<Up>'] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),
                    ['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),
                    ['<C-j>'] = cmp.mapping(cmp.mapping.select_next_item(), { "c" }),
                    ['<C-k>'] = cmp.mapping(cmp.mapping.select_prev_item(), { "c" }),
                    ['<Tab>'] = cmp.mapping.confirm { behavior = cmp.ConfirmBehavior.Replace, select = true },
                    ['<C-e>'] = cmp.mapping.abort(),
                    ['<CR>'] = cmp.mapping(function(fallback)
                        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<C-g>u', true, true, true), 'n', true)
                        cmp.mapping.confirm({ select = true })(fallback)
                    end, { 'i', 's' })
                },
                sources = {
                    { name = "nvim_lsp", priority = 20 },
                    { name = 'luasnip', priority = 7 },
                    { name = "buffer", priority = 5, keyword_length = 5, max_item_count = 10 },
                    { name = "path", priority = 4 },
                },
            })
            cmp.setup.cmdline({ '/', '?' }, {
                window = { completion = cmp.config.window.bordered({ border = 'none' }) },
                completion = { completeopt = 'menu,menuone,noselect' },
                formatting = { fields = { 'abbr' } },
                mapping = cmp.mapping.preset.cmdline(),
                sources = {
                    { name = 'buffer' }
                }
            })
            cmp.setup.cmdline(':', {
                window = { completion = cmp.config.window.bordered({ border = 'none' }) },
                completion = { completeopt = 'menu,menuone,noselect' },
                formatting = { fields = { 'abbr' } },
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