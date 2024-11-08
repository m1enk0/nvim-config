return {
    "romainl/vim-qf",
    event = "VeryLazy",
    keys = {
        { "<A-o>", "<cmd>call qf#toggle#ToggleQfWindow(0)<cr>" }
    },
    config = function()
        vim.cmd("let g:qf_mapping_ack_style = 1")
    end
}
