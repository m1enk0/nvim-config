return {
    "danielfalk/smart-open.nvim",
    lazy = false,
    dependencies = {
        "kkharji/sqlite.lua"
    },
    config = function()
        vim.cmd[[let g:sqlite_clib_path = "C:\\Users\\Andrey\\sqlite\\sqlite3.dll"]]
        require("telescope").load_extension("smart_open")
    end
}
