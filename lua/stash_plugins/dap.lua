return {
    {
        'mfussenegger/nvim-dap',
        dependencies = {
            'rcarriga/nvim-dap-ui',
            'jay-babu/mason-nvim-dap.nvim',
        },
        cmd = { 'DapContinue', 'DapToggleBreakpoint' },
        config = function()
            global.map_key("n", "<C-_>", "<cmd>DapToggleBreakpoint<cr>", global.map_key_opts)
            global.map_key("n", "<C-n>", "<cmd>DapContinue<cr>", global.map_key_opts)
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
            global.map_key("n", "<C-u>", "<cmd>lua require('dapui').toggle()<cr>", global.map_key_opts)
            global.map_key("n", "<A-/>", "<cmd>lua require('dapui').eval()<cr>", global.map_key_opts)
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
