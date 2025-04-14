local recent_files = require('recents')

-- Add to the top of your file
local devicons_ok, devicons = pcall(require, 'nvim-web-devicons')
if not devicons_ok then
  devicons = nil
end

-- First, ensure we have the dropdown extension available
pcall(require, 'telescope.themes') -- Load telescope themes
local dropdown = require('telescope.themes').get_dropdown()

local function recent_files_picker(opts)
    opts = opts or {}
    local function filter_existing_files(files)
        return vim.tbl_filter(function(file)
            return vim.fn.filereadable(file) == 1
        end, files)
    end

    local existing_files = filter_existing_files(recent_files.get_recent_files())
    recent_files.update_files(existing_files) -- Update the stored list

    -- Merge our defaults with user options
    local picker_opts = vim.tbl_deep_extend('force', {
        prompt_title = 'Recent Files',
        -- default_selection_index = 2,
    }, dropdown, opts) -- Merge with dropdown theme

    local pickers = require('telescope.pickers')
    local finders = require('telescope.finders')
    local conf = require('telescope.config').values
    local actions = require('telescope.actions')
    local action_state = require('telescope.actions.state')

    pickers.new(picker_opts, {
        finder = finders.new_table({
            results = recent_files.get_recent_files(),
            entry_maker = function(entry)
                local icon, icon_color = '', ''
                if devicons then
                    local filename = vim.fn.fnamemodify(entry, ':t')
                    local extension = vim.fn.fnamemodify(entry, ':e')
                    icon, icon_color = devicons.get_icon_color(filename, extension, { default = true })
                end
                return {
                    value = entry,
                    display = string.format('%s %s', icon ~= '' and icon or ' ', filenameFirst(_, entry)),
                    ordinal = entry,
                }
            end
        }),
        sorter = conf.generic_sorter(picker_opts),
        attach_mappings = function(prompt_bufnr, map)
            actions.select_default:replace(function()
                actions.close(prompt_bufnr)
                local selection = action_state.get_selected_entry()
                vim.cmd('edit ' .. selection.value)
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