local M = {}

-- Configuration defaults
local config = {
  session_file = vim.fn.stdpath('data') .. '/recent_files/' .. vim.fn.fnamemodify(vim.fn.getcwd(), ':t') .. "_" .. vim.fn.sha256(vim.fn.getcwd()),
  max_entries = 1000,
}

-- Setup function to override defaults
function M.setup(user_config)
  config = vim.tbl_deep_extend('force', config, user_config or {})
end

local recent_files = {}

local function load_recent_files()
    local ok, lines = pcall(function()
        return vim.fn.readfile(config.session_file)
    end)

    if ok then
        recent_files = lines
    else
        recent_files = {}
    end
end

-- Save recent files to session file
local function save_recent_files()
    vim.fn.writefile(recent_files, config.session_file)
end

local function is_file(path)
  if path == '' then return false end
  local stat = vim.loop.fs_stat(path)
  return stat and stat.type == 'file'
end

function M.add_file(filepath)
    if not filepath or filepath == '' then return end
    if not is_file(filepath) then return end

    -- local normalized_path = vim.fn.fnamemodify(filepath, ':p'):gsub("\\", "/")
    filepath = filepath:gsub("\\", "/"):gsub("^%l", string.upper)
    -- local normalized_path = vim.fn.fnamemodify(filepath, ':p')

    -- Remove the file if it already exists (to avoid duplicates)
    recent_files = vim.tbl_filter(function(f)
       -- if vim.fn.has("win32") == 1 then         -- On Windows, make comparison case-insensitive
       --      p = p:lower()
       --  end
        return f ~= filepath
        -- return vim.n.fnamemodify(f, ':p') ~= normalized_path
    end, recent_files)

    -- Add to the beginning of the list
    table.insert(recent_files, 1, filepath)

    -- Trim the list if it's too long
    if #recent_files > config.max_entries then
        recent_files = vim.list_slice(recent_files, 1, config.max_entries)
    end

    save_recent_files()
end

-- Get recent files for Telescope
function M.get_recent_files()
    return recent_files
end

function M.update_files(new_files)
    recent_files = new_files
    save_recent_files()
end

function M.clean_nonexistent_files()
    local existing = vim.tbl_filter(function(file)
        return vim.fn.filereadable(file) == 1
    end, recent_files)

    if #existing ~= #recent_files then
        recent_files = existing
        save_recent_files()
    end
end

local group = vim.api.nvim_create_augroup('RecentFilesTracker', { clear = true })
vim.api.nvim_create_autocmd('BufEnter', {
    group = group,
    callback = function(args)
        local bufname = vim.api.nvim_buf_get_name(args.buf)
        if bufname ~= '' and not vim.startswith(bufname, 'neo-tree') then
            M.add_file(bufname)
        end
    end,
})

-- Initialize the module
load_recent_files()

return M