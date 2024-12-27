return {
    lazy = false,
    "danielfalk/smart-open.nvim",
    branch = "0.2.x",
    dependencies = {
        "kkharji/sqlite.lua",
    },
    config = function()
        vim.cmd('let g:sqlite_clib_path = "C:/Users/Andrey/sqlite/sqlite3.dll"')
        require("telescope").load_extension("smart_open")
    end
}
