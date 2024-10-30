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
                    mappings = {
                        i = { ["<esc>"] = "close" }
                    },
                    path_display = filenameFirst,
                    file_ignore_patterns = { ".git", "target" },
                },
                pickers = {
                    find_files = {
                        theme = "dropdown",
                        find_files = {
                            path_display = filenameFirst,
                        }
                    },
                    command_history = {
                        theme = "dropdown"
                    },
                    live_grep = {
                        theme = "dropdown"
                    },
                    buffers = {
                        theme = "ivy"
                    },
                    help_tags = {
                        theme = "dropdown"
                    },
                    oldfiles = {
                        theme = "dropdown"
                    },
                    git_status = {
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
