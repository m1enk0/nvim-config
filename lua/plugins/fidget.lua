return {
    'j-hui/fidget.nvim',
    event = "VeryLazy",
    config = function()
        require("fidget").setup({
            progress = {
                display = {
                    done_ttl = 0,
                    done_icon = "✓"
                }
            },
            notification = {
                window = {
                    winblend = 0
                }
            }
        })
    end
}
