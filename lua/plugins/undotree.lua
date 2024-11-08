return {
    'mbbill/undotree',
    keys = { -- load the plugin only when using it's keybinding:
        { "<leader>u", "<cmd>UndotreeToggle | UndotreeFocus<cr>" },
    },
    config = function()
        vim.cmd('let g:undotree_DiffAutoOpen = 0')
        vim.cmd('let g:undotree_WindowLayout = 2')
    end
}
