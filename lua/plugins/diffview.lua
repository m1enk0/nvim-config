return {
    'sindrets/diffview.nvim',
    cmd = { "DiffviewOpen", "DiffviewFileHistory" },
    config = function()
        local actions = require('diffview').actions
        require('diffview').setup({
            keymaps = {
                view = {
                    { "n", "<S-A-n>", "]c" },
                    { "n", "<S-A-p>", "[c" },
                }
            },
            file_panel = {
                listing_style = "list"
            }
        })

        vim.cmd[[
            hi DiffviewFilePanelTitle guifg=#A9B7C6
            hi DiffviewFolderSign guifg=#A9B7C6
        ]]
    end
}
