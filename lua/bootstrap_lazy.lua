local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        'git',
        'clone',
        '--filter=blob:none',
        'https://github.com/folke/lazy.nvim.git',
        '--branch=stable', -- latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

local plugins = {
    { import = "plugins" },
    { import = "plugins/local" }
}
local settings = {
    checker = {
        enabled = false
    },
    defaults = {
        lazy = true,
    },
    change_detection = {
        enabled = false
    },
    performance = {
        cache = {
            enabled = true,
            path = vim.fn.stdpath("cache") .. "/lazy/cache",
            -- Once one of the following events triggers, caching will be disabled.
            -- To cache all modules, set this to `{}`, but that is not recommended.
            -- The default is to disable on:
            --  * VimEnter: not useful to cache anything else beyond startup
            --  * BufReadPre: this will be triggered early when opening a file from the command line directly
            disable_events = { "VimEnter", "BufReadPre" }
        }
    },
    reset_packpath = true, -- reset the package path to improve startup time
    rocks = { enabled = false }
}
require("lazy").setup(plugins, settings)
