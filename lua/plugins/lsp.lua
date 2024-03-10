return {
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
	    local lspconfig = require'lspconfig'
	    local util = require'lspconfig/util'
	    lspconfig.thriftls.setup {}
	    lspconfig.lua_ls.setup {}
	    lspconfig.jdtls.setup {}
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
