return {
    --map('n','gD','<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
    --map('n','gd',':Telescope lsp_definitions<cr>', opts)
    --map("n", "gd", "<Plug>(coc-definition)", {silent = true})
    --map("n", "gd", require("definition-or-references").definition_or_references, opts)
    --map("n", "<S-A-f>", ":lua vim.lsp.buf.format()<cr>", {})
    --map('n','gr',':Telescope lsp_references<cr>', opts)
    --map('n','gs','<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
    --map('n','gi',':Telescope lsp_implementations<cr>', opts)
    --map('n','gt','<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
    --map('n','<leader>gw','<cmd>lua vim.lsp.buf.document_symbol()<CR>', opts)
    --map('n','<leader>gW','<cmd>lua vim.lsp.buf.workspace_symbol()<CR>', opts)
    --map('n','<leader>ah','<cmd>lua vim.lsp.buf.hover()<CR>', opts)
    --map('n','<A-CR>','<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
    --map('n','<leader>ee','<cmd>lua vim.lsp.util.show_line_diagnostics()<CR>', opts)
    --map('n','<leader>ar','<cmd>lua vim.lsp.buf.rename()<CR>', opts)
    --map('n','<leader>ai','<cmd>lua vim.lsp.buf.incoming_calls()<CR>', opts)
    --map('n','<leader>ao','<cmd>lua vim.lsp.buf.outgoing_calls()<CR>', opts)
    --map('n','<leader>ls',':LspStart<cr>', opts)
    --map('n','<leader>lr',':LspRestart<cr>', opts)
    --map('n', '<A-r>', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
    {
        "williamboman/mason.nvim",
        config = function()
            require("mason").setup({
                PATH = "prepend"
            })
        end
    },
    {
        "williamboman/mason-lspconfig.nvim",
        config = function()
            require("mason-lspconfig").setup({
                ensure_installed = { "lua_ls" }
            })
        end
    },
    {
        "neovim/nvim-lspconfig",
        config = function()
            local lspconfig = require 'lspconfig'
            local util = require 'lspconfig/util'
            lspconfig.thriftls.setup {}
            lspconfig.lua_ls.setup {}
            lspconfig.jdtls.setup {
                autostart = false
            }
            lspconfig.gopls.setup {
                cmd = { "gopls" },
                filetypes = { "go", "gomod", "gowork", "gotmpl" },
                root_dir = util.root_pattern("go.work", "go.mod", ".git")
            }
        end
    },
    {
        'hrsh7th/cmp-nvim-lsp', -- LSP source for nvim-cmp,
        config = function()
            require("cmp_nvim_lsp").default_capabilities()
        end
    },
    {
        'hrsh7th/nvim-cmp', -- Autocompletion plugin,
        dependencies = {
            'L3MON4D3/LuaSnip',
            'rafamadriz/friendly-snippets',
            'saadparwaiz1/cmp_luasnip',
            -- 'SirVer/ultisnips',
            -- 'quangnguyen30192/cmp-nvim-ultisnips'
        },
        config = function()
            local cmp = require("cmp")
            require("luasnip.loaders.from_vscode").lazy_load()
            cmp.setup({
                snippet = {
                    expand = function(args)
                        --vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
                        require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
                        -- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
                    end,
                },
                sources = {
                    { name = 'nvim_lsp' },
                    { name = "buffer" },
                    { name = 'luasnip' }, -- For luasnip users.
                    -- { name = 'ultisnips' }, -- For ultisnips users.
                    -- { name = 'vsnip' }, -- For vsnip users.
                },
                mapping = cmp.mapping.preset.insert({
                    ['<C-Space>'] = cmp.mapping.complete(),
                    ['<CR>'] = cmp.mapping.confirm {
                        behavior = cmp.ConfirmBehavior.Insert,
                        select = true,
                    },
                    ['<Tab>'] = cmp.mapping.confirm {
                        behavior = cmp.ConfirmBehavior.Replace,
                        select = true,
                    },
                }),
            })
        end
    },
}
