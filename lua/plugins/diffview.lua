return {
    'sindrets/diffview.nvim',
    cmd = { "DiffviewOpen", "DiffviewFileHistory" },
    config = function()
        require('diffview').setup({
            file_panel = {
                listing_style = "list"
            }
        })
    end
}
