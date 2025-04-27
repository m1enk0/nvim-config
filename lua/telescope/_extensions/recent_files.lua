local recent_files = require('recents')

-- Add to the top of your file
local devicons_ok, devicons = pcall(require, 'nvim-web-devicons')
if not devicons_ok then
  devicons = nil
end

local function entry_maker(entry)
    local icon, icon_color = '', ''
    if devicons then
        local filename = vim.fn.fnamemodify(entry.path, ':t')
        local extension = vim.fn.fnamemodify(entry.path, ':e')

        icon, icon_color = devicons.get_icon_color(filename, extension, { default = true })
    end
    return {
        value = entry.path,
        display = string.format('%s %s', icon ~= '' and icon or ' ', filenameFirst(_, entry.path)),
        ordinal = entry.path,
        timestamp = entry.timestamp
    }
end

-- First, ensure we have the dropdown extension available
pcall(require, 'telescope.themes') -- Load telescope themes
local dropdown = require('telescope.themes').get_dropdown()

local function recent_files_picker(opts)
    opts = opts or {}

    recent_files.sync_files()
    local results = recent_files.get_recent_files_with_timestamps()

    -- Merge our defaults with user options
    local picker_opts = vim.tbl_deep_extend('force', {
        prompt_title = 'Recent Files',
        cache_picker = false
        -- default_selection_index = 2,
    }, dropdown, opts) -- Merge with dropdown theme

    local pickers = require('telescope.pickers')
    local finders = require('telescope.finders')
    local conf = require('telescope.config').values
    local actions = require('telescope.actions')
    local action_state = require('telescope.actions.state')
    local sorters = require('telescope.sorters')
    local generic_sorter = conf.generic_sorter(picker_opts)

    local min_timestamp, max_timestamp = math.huge, -math.huge
    for _, entry in ipairs(results) do
        if entry.timestamp < min_timestamp then
            min_timestamp = entry.timestamp
        end
        if entry.timestamp > max_timestamp then
            max_timestamp = entry.timestamp
        end
    end

    local original_scoring = generic_sorter.scoring_function
    generic_sorter.scoring_function = function(self, prompt, line, entry)
        local original_score = original_scoring(self, prompt, line, entry) or 0
        local score = original_score
        if original_score > 0 and prompt:len() > 0 then
            local norm_timestamp = (entry.timestamp - min_timestamp) / (max_timestamp - min_timestamp)
            score = score - norm_timestamp * 0.01
        end
        return score
    end

    pickers.new(picker_opts, {
        finder = finders.new_table({
            results = results,
            entry_maker = entry_maker
        }),
        sorter = generic_sorter,
        attach_mappings = function(prompt_bufnr, map)
            actions.select_default:replace(function()
                actions.close(prompt_bufnr)
                local selection = action_state.get_selected_entry()
                if selection and selection.value then
                    vim.cmd('edit ' .. selection.value)
                else
                    vim.notify("No valid file selected", vim.log.levels.WARN)
                end
            end)

            map('i', '<Del>', function()
                local selection = action_state.get_selected_entry()
                if selection then
                    recent_files.delete_entry(selection.value)
                    local picker = action_state.get_current_picker(prompt_bufnr)
                    picker:refresh(finders.new_table({
                        results = recent_files.get_recent_files_with_timestamps(),
                        entry_maker = entry_maker
                    }))
                end
            end)
            return true
        end,
    }):find()
end

return require('telescope').register_extension({
    exports = {
        recent_files = recent_files_picker
    }
})