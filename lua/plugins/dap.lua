return {
    {
        'mfussenegger/nvim-dap',
        dependencies = {
            'rcarriga/nvim-dap-ui',
            'jay-babu/mason-nvim-dap.nvim',
            'jbyuki/one-small-step-for-vimkind',
        },
        cmd = { 'DapContinue', 'DapToggleBreakpoint' },
        keys = {
            { "<C-n>", "<cmd>DapContinue<cr>" },
            { "<C-_>", "<cmd>DapToggleBreakpoint<cr>" }
        },
        config = function()
            local dap = require('dap')
            dap.adapters.nlua = function(callback, config)
                callback({ type = 'server', host = config.host or "127.0.0.1", port = config.port or 8086 })
            end
            dap.configurations.lua = { 
                { 
                    type = 'nlua', 
                    request = 'attach',
                    name = "Attach to running Neovim instance",
                }
            }
            dap.configurations.java = {
                {
                    type = "java",
                    request = "attach",
                    name = "Attach to Spring Boot",
                    hostName = "127.0.0.1",
                    port = 5005,
                },
            }

            global.map_key("n", "<C-m>", "<cmd>DapStepOver<cr>", global.map_key_opts)
            global.map_key("n", "<leader>m", "<cmd>DapStepInto<cr>", global.map_key_opts)
            global.map_key("n", "<leader>M", "<cmd>DapStepOut<cr>", global.map_key_opts)
            global.map_key("n", "<leader>/", "<cmd>DapEval<cr>", global.map_key_opts)
            global.map_key("n", "<leader>b", "<cmd>lua require('dap').focus_frame()<cr>", global.map_key_opts)
        end
    },
    {
        'rcarriga/nvim-dap-ui',
        config = function()
            local dapui = require('dapui')
            local dap = require('dap')
            dapui.setup({
                layouts = {
                    {
                        elements = {
                            { id = "stacks", size = 0.5 },
                            { id = "scopes",  size = 0.5 },
                        },
                        position = "bottom",
                        size = 15
                    },
                }
            })
            dap.listeners.after.event_initialized['dapui_config'] = function()
                vim.notify('dap event_initialized')
            end
            dap.listeners.before.event_terminated['dapui_config'] = function()
                dapui.close()
            end
            dap.listeners.before.event_exited['dapui_config'] = function()
                dapui.close()
            end

            global.map_key("n", "<C-u>", "<cmd>lua require('dapui').toggle()<cr>", global.map_key_opts)
            global.map_key("n", "<A-/>", "<cmd>lua require('dapui').eval()<cr>", global.map_key_opts)
            global.map_key("n", "<leader>fb", "<cmd>lua require('dapui').float_element('breakpoints', { enter = true })<cr>", global.map_key_opts)
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
