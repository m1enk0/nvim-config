local M = {}

-- Configuration defaults
local config = {
  session_file = vim.fn.stdpath('data') .. '/recent_files2/' .. vim.fn.fnamemodify(vim.fn.getcwd(), ':t') .. "_" .. vim.fn.sha256(vim.fn.getcwd()),
  max_entries = 1000,
}

-- Setup function to override defaults
function M.setup(user_config)
  config = vim.tbl_deep_extend('force', config, user_config or {})
end

local recent_files = {}

local function load_recent_files()
    local ok, content = pcall(function()
        return vim.fn.readfile(config.session_file)
    end)

    if ok then
        recent_files = vim.tbl_map(function(line)
            return vim.json.decode(line)
        end, content)
    else
        recent_files = {}
    end
end

-- Save recent files to session file
local function save_recent_files()
    local content = vim.tbl_map(function(entry)
        return vim.json.encode(entry)
    end, recent_files)
    vim.fn.writefile(content, config.session_file)
end

local function is_file(path)
  if path == '' then return false end
  local stat = vim.loop.fs_stat(path)
  return stat and stat.type == 'file'
end

local function filter_existing_files(files)
    return vim.tbl_filter(function(file)
        return vim.fn.filereadable(file.path) == 1
    end, files)
end

function M.add_file(filepath)
    if not filepath or filepath == '' then return end
    if not is_file(filepath) then return end

    filepath = filepath:gsub("\\", "/"):gsub("^%l", string.upper)
    local timestamp = os.time()

    recent_files = vim.tbl_filter(function(entry)
        return entry.path ~= filepath
    end, recent_files)

    table.insert(recent_files, 1, {
        path = filepath,
        timestamp = timestamp
    })

    if #recent_files > config.max_entries then
        recent_files = vim.list_slice(recent_files, 1, config.max_entries)
    end

    save_recent_files()
end

function M.get_recent_files_with_timestamps()
    return recent_files
end

function M.sync_files()
    recent_files = filter_existing_files(recent_files)
    save_recent_files()
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