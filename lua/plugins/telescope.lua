vim.api.nvim_create_autocmd("FileType", {
    pattern = "TelescopeResults",
    callback = function(ctx)
        vim.api.nvim_buf_call(ctx.buf, function()
            vim.fn.matchadd("TelescopeParent", "\t\t.*$")
            vim.api.nvim_set_hl(0, "TelescopeParent", { link = "Comment" })
        end)
    end,
})

local function filenameFirst(_, path)
    local tail = vim.fs.basename(path)
    local parent = vim.fs.dirname(path)
    if parent == "." then return tail end
    local lim = 71  -- current result window size const
    if string.len(parent) + string.len(tail) > lim then
        if string.len(tail) > lim then
            return ".." .. string.sub(tail, -lim)
        end
        parent = ".." .. string.sub(parent, -(lim - string.len(tail)))
    end
    return string.format("%s\t\t%s", tail, parent)
end

local function get_current_picker_prompt(prompt_bufnr)
    return require('telescope.actions.state').get_current_picker(prompt_bufnr):_get_prompt()
end

return {
    'nvim-telescope/telescope.nvim',
    tag = '0.1.8',
    dependencies = { 'nvim-lua/plenary.nvim' },
    event = "VeryLazy",
    config = function()
        local builtin = require('telescope.builtin')
        require("telescope").setup {
            defaults = {
                prompt_prefix = "",
                cache_picker = {
                    ignore_empty_prompt = true,
                    num_pickers = 150,
                    limit_entries = 150
                },
                mappings = {
                    i = {
                        ["<esc>"] = "close",
                        ["<C-f>"] = "to_fuzzy_refine",
                        ["<C-Down>"] = "cycle_history_next",
                        ["<C-Up>"] = "cycle_history_prev",
                        ["<C-h>"] = function(prompt_bufnr)
                            local text = get_current_picker_prompt(prompt_bufnr)
                            require("telescope.actions").close(prompt_bufnr)
                            builtin.find_files { default_text = text }
                        end,
                        ["<C-l>"] = function(prompt_bufnr)
                            local text = get_current_picker_prompt(prompt_bufnr)
                            require("telescope.actions").close(prompt_bufnr)
                            builtin.live_grep { default_text = text }
                        end
                    }
                },
                path_display = filenameFirst,
                file_ignore_patterns = { "^.git\\", "target", "^build\\", "^bin\\", "%.exe" },
            },
            pickers = {
                find_files = {
                    theme = "dropdown",
                    no_ignore = true
                },
                command_history = {
                    cache_picker = false,
                    theme = "dropdown"
                },
                live_grep = {
                    theme = "dropdown",
                    no_ignore = true
                },
                buffers = {
                    cache_picker = false,
                    sort_mru = true,
                    theme = "dropdown",
                    previewer = false,
                    ignore_current_buffer = true
                },
                help_tags = {
                    cache_picker = false,
                    theme = "dropdown"
                },
                oldfiles = {
                    cache_picker = false,
                    sort_mru = true,
                    theme = "dropdown",
                    previewer = false,
                    wrap_results = true,
                },
                git_status = {
                    cache_picker = false,
                    path_display = filenameFirst,
                    -- theme = "ivy",
                    mappings = {
                        i = {
                            ["<C-l>"] = "close",
                        },
                        n = {
                            ["<C-l>"] = "close",
                        }
                    }
                },
                git_branches = {
                    cache_picker = false,
                    previewer = false,
                    theme = "dropdown"
                },
                lsp_references = {
                    cache_picker = false,
                    include_declaration = false,
                    theme = "dropdown"
                },
                lsp_definitions = {
                    cache_picker = false,
                    theme = "dropdown"
                },
                lsp_implementations = {
                    cache_picker = false,
                    theme = "dropdown"
                }
            }
        }
    end
}