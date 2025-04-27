return {
    {
        'mfussenegger/nvim-dap',
        dependencies = {
            'rcarriga/nvim-dap-ui',
            'jay-babu/mason-nvim-dap.nvim',
        },
        cmd = { 'DapContinue', 'DapToggleBreakpoint' },
        config = function()
            MAP_KEY("n", "<C-_>", "<cmd>DapToggleBreakpoint<cr>", MAP_KEY_OPTS)
            MAP_KEY("n", "<C-n>", "<cmd>DapContinue<cr>", MAP_KEY_OPTS)
        end
    },
    {
        'rcarriga/nvim-dap-ui',
        config = function()
            local dap = require('dap')
            local dapui = require('dapui')
            dapui.setup({
                layouts = {
                    {
                        elements = {
                            { id = "console", size = 0.75 },
                            { id = "scopes",  size = 0.25 },
                        },
                        position = "bottom",
                        size = 15
                    },
                }
            })
            dap.listeners.after.event_initialized['dapui_config'] = function()
                dapui.open()
            end
            dap.listeners.before.event_terminated['dapui_config'] = function()
                dapui.close()
            end
            dap.listeners.before.event_exited['dapui_config'] = function()
                dapui.close()
            end
            MAP_KEY("n", "<C-u>", "<cmd>lua require('dapui').toggle()<cr>", MAP_KEY_OPTS)
            MAP_KEY("n", "<A-/>", "<cmd>lua require('dapui').eval()<cr>", MAP_KEY_OPTS)
        end
    },
    {
        'jay-babu/mason-nvim-dap.nvim',
        dependencies = {
            'williamboman/mason.nvim',
            'nvim-neotest/nvim-nio'
        },
        opts = {
            handlers = {}
        },
    }
}
