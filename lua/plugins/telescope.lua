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
    local lim = 71
    if string.len(parent) + string.len(tail) > lim then
        if string.len(tail) > lim then
            return ".." .. string.sub(tail, -lim)
        end
        parent = ".." .. string.sub(parent, -(lim - string.len(tail)))
    end
    return string.format("%s\t\t%s", tail, parent)
end

return {
    {
        'nvim-telescope/telescope.nvim',
        tag = '0.1.5',
        dependencies = { 'nvim-lua/plenary.nvim' },
        config = function()
            require("telescope").setup {
                defaults = {
                    cache_picker = {
                        num_pickers = 1000,
                        limit_entries = 1
                    },
                    mappings = {
                        i = {
                            ["<esc>"] = "close",
                            ["<C-f>"] = "to_fuzzy_refine",
                            ["<C-Down>"] = "cycle_history_next",
                            ["<C-Up>"] = "cycle_history_prev"
                        }
                    },
                    path_display = filenameFirst,
                    file_ignore_patterns = { ".git", "target", "^build\\" },
                },
                pickers = {
                    find_files = {
                        theme = "dropdown",
                        no_ignore = true,
                    },
                    command_history = {
                        theme = "dropdown"
                    },
                    live_grep = {
                        theme = "dropdown",
                        no_ignore = true
                    },
                    buffers = {
                        theme = "ivy"
                    },
                    help_tags = {
                        theme = "dropdown"
                    },
                    oldfiles = {
                        sort_mru = true,
                        theme = "dropdown",
                        previewer = false
                    },
                    git_status = {
                        path_display = filenameFirst,
                        theme = "ivy",
                        mappings = {
                            i = {
                                ["<C-l>"] = "close",
                            },
                            n = {
                                ["<C-l>"] = "close",
                            }
                        }
                    },
                    lsp_references = {
                        theme = "dropdown"
                    },
                    lsp_definitions = {
                        theme = "dropdown"
                    },
                    lsp_implementations = {
                        theme = "dropdown"
                    }
                }
            }
        end
    }
}
