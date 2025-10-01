local M = {}

-- Configuration defaults
local config = {
  session_file = vim.fn.stdpath('data') .. '/recent_files/' .. vim.fn.fnamemodify(vim.fn.getcwd(), ':t') .. "_" .. vim.fn.sha256(vim.fn.getcwd()),
  max_entries = 150,
  excludes = { "COMMIT_EDITMSG" }
}

-- Setup function to override defaults
function M.setup(user_config)
  config = vim.tbl_deep_extend('force', config, user_config or {})
end

local recent_files = {}

local function ensure_directory_exists()
    local dir = vim.fn.fnamemodify(config.session_file, ':h')
    if vim.fn.isdirectory(dir) == 0 then
        vim.fn.mkdir(dir, 'p')
    end
end

local function load_recent_files()
    ensure_directory_exists()
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

local function is_excluded(path)
    for _, pattern in ipairs(config.excludes or {}) do
        if path:match(pattern) then
            return true
        end
    end
    return false
end

local function filter_existing_files(files)
    return vim.tbl_filter(function(file)
        return vim.fn.filereadable(file.path) == 1
    end, files)
end

function M.add_file(filepath)
    if not filepath or filepath == '' then return end
    if not is_file(filepath) then return end
    if is_excluded(filepath) then return end

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

function M.delete_entry(filepath)
    if not filepath or filepath == '' then return false end
    local found = false
    recent_files = vim.tbl_filter(function(entry)
        if entry.path == filepath then
            found = true
            return false
        end
        return true
    end, recent_files)
    if found then save_recent_files() end
    return found
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

vim.api.nvim_create_autocmd('UIEnter', {
    pattern = '*',
    callback = function()
        if vim.bo.buftype == 'nofile' or vim.fn.argc() > 0 then
            return
        end
        M.sync_files()
        local most_recent = recent_files[1]
        if #recent_files > 0 then
            vim.schedule(function() vim.cmd('edit ' .. vim.fn.fnameescape(most_recent.path)) end)
            if #recent_files > 1 then
                vim.schedule(function()
                    local second_path = recent_files[2].path
                    if second_path and vim.fn.filereadable(second_path) == 1 then
                        vim.cmd('badd ' .. vim.fn.fnameescape(second_path))
                        vim.fn.setreg('#', second_path)
                    end
                end)
            end
        end
    end,
    nested = true
})

load_recent_files()

return M