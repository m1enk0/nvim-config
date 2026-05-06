vim.api.nvim_create_user_command('ReexecuteQuery', global.reexecute_query, {})
vim.api.nvim_create_user_command('ExecuteYankedToSplit', global.execute_yanked_to_split, {})

global.map_key('v', '<leader>ee', 'y:ExecuteYankedToSplit<CR>', global.map_key_opts)
global.map_key('n', '<leader>ee', 'vipy:ExecuteYankedToSplit<CR>', global.map_key_opts)
