vim.api.nvim_create_autocmd("FileType", {
    pattern = "TelescopeResults",
    callback = function(ctx)
        vim.api.nvim_buf_call(ctx.buf, function()
            vim.fn.matchadd("TelescopeParent", "\t\t.*$")
            vim.api.nvim_set_hl(0, "TelescopeParent", { link = "Comment" })
        end)
    end,
})

function filenameFirst(_, path)
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

local function dynamic_fzy_sorter()
    local telescope = require('telescope')
    local sorters = require('telescope.sorters')
    local file_sorter = telescope.extensions.fzy_native.native_fzy_sorter()
    local fzy = require('telescope.algos.fzy')
    -- local file_sorter = sorters.get_fzy_sorter()
    local original_scoring_func = file_sorter.scoring_function

    local dec_score_function = function(_, prompt, line, entry)
        local words = {}
        for word in prompt:gmatch("%S+") do table.insert(words, word) end
        local filename = vim.fs.basename(entry.value)
        local score = 0

        if #words == 0 then
            score = original_scoring_func(_, prompt, line, entry)
        elseif #words == 1 then
            score = original_scoring_func(_, prompt:gsub("%s+", ""), filename, entry)
        else
            local filename_score = original_scoring_func(_, words[1], filename, entry)
            if filename_score <= 0 then
                return -1
            end
            local remaining_words = table.concat(words, "", 2)
            local path_score = original_scoring_func(_, remaining_words, vim.fs.dirname(entry.value), entry)
            if path_score > 0 then
                score = filename_score + path_score
            else
                return -1
            end
        end
        return score
    end

    local dec_highlighter = function(_, prompt, display)
        local words = {}
        for word in prompt:gmatch("%S+") do table.insert(words, word) end

        local highlights = {}

        if #words == 0 or #words == 1 then
            -- Use original fzy positions on the full display (standard behavior)
            return fzy.positions(prompt, display) or {}
        end

        -- Multiple words: split display into path and filename
        local sep = display:find(vim.pesc(vim.fs.basename(display)) .. "$")
        local path_part = display:sub(1, sep and sep - 2 or 0)  -- exclude trailing path separator if present
        local filename_part = vim.fs.basename(display)

        -- Highlight filename matches for first word
        local filename_pos = fzy.positions(words[1], filename_part)
        if filename_pos then
            local offset = #path_part + (#path_part > 0 and 1 or 0)  -- account for path separator
            for _, p in ipairs(filename_pos) do
                table.insert(highlights, p + offset)
            end
        else
            -- No filename match → should be filtered already, but safe
            return {}
        end

        -- Highlight path matches for remaining words
        local remaining_prompt = table.concat(words, " ", 2)
        local path_pos = fzy.positions(remaining_prompt, path_part)
        if path_pos then
            for _, p in ipairs(path_pos) do
                table.insert(highlights, p)
            end
        end

        table.sort(highlights)
        return highlights
    end

    return sorters.new {
        scoring_function = dec_score_function,
        old_scoring_function = file_sorter.scoring_function,
        highlighter = dec_highlighter
    }
end

local function get_current_picker_prompt(prompt_bufnr)
    return require('telescope.actions.state').get_current_picker(prompt_bufnr):_get_prompt()
end

return {
    'nvim-telescope/telescope.nvim',
    tag = '0.1.8',
    dependencies = {
        'nvim-lua/plenary.nvim',
        'nvim-tree/nvim-web-devicons',
        'nvim-telescope/telescope-ui-select.nvim',
        'nvim-telescope/telescope-fzy-native.nvim'
    },
    event = "VeryLazy",
    config = function()
        local file_ignore_patterns  = { "^.git\\", "target", "^build\\", "^bin\\", "%.exe" }
        local settings = require("custom.project_settings").get_settings()
        if settings and settings.telescope and settings.telescope.append_file_ignore_patterns then
            for _, pattern in ipairs(settings.telescope.append_file_ignore_patterns) do
                table.insert(file_ignore_patterns, pattern)
            end
        end

        local builtin = require('telescope.builtin')
        require("nvim-web-devicons").setup({ override = { java = { icon = "🅹", color = "#3E86A0", name = "java" } } })
        require("telescope").setup {
            defaults = {
                file_sorter = dynamic_fzy_sorter,
                -- file_entry_maker = default_file_entry,
                scroll_strategy = "limit",
                sorting_strategy = "ascending",
                entry_prefix = " ",
                selection_caret = " ",
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
                        ["<A-e>"] = function(prompt_bufnr)
                            local text = get_current_picker_prompt(prompt_bufnr)
                            require("telescope.actions").close(prompt_bufnr)
                            builtin.find_files { default_text = text }
                        end,
                        ["<A-l>"] = function(prompt_bufnr)
                            local text = get_current_picker_prompt(prompt_bufnr)
                            require("telescope.actions").close(prompt_bufnr)
                            builtin.live_grep { default_text = text }
                        end
                    }
                },
                path_display = filenameFirst,
                file_ignore_patterns = file_ignore_patterns,
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
                    layout_config = {
                        width = 0.7,
                    }
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
                    sort_lastused = true,
                    theme = "dropdown",
                    previewer = false,
                    wrap_results = true,
                },
                git_status = {
                    cache_picker = false,
                    path_display = filenameFirst,
                    wrap_results = true,
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
                    theme = "dropdown",
                    -- pattern = "--sort committerdate"
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
                },
                current_buffer_fuzzy_find = {
                    previewer = false
                },
                fd = {
                    wrap_results = true,
                    path_display = "smart",
                }
            },
            extensions = {
                ["ui-select"] = {
                    require("telescope.themes").get_dropdown({}),
                    cache_picker = false
                },
                recent_files = {
                    max_entries = 150
                },
                -- ["zf-native"] = {
                --     file = { enable = false, },
                --     generic = { enable = false, },
                -- },
                fzy_native = {
                    override_generic_sorter = true,
                    override_file_sorter = false
                }
            },
        }
        require('telescope').load_extension('fzy_native')
        require("telescope").load_extension("ui-select")
        -- require("telescope").load_extension("zf-native")
        require("telescope").load_extension("recent_files")
    end
}
