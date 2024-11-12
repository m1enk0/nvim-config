return {
    'L3MON4D3/LuaSnip',
    enabled = false,
    event = "VeryLazy",
    dependencies = {
        'rafamadriz/friendly-snippets'
    },
    version = "v2.3.0",
    build = "make install_jsregexp",
    config = function()
        require("luasnip.loaders.from_vscode").lazy_load()
    end
}
