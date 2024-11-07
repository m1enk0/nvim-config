local ok, telescope = pcall(require, "telescope")
if ok then
    vim.api.nvim_set_hl(0, "TelescopeNormal", { bg = "#262626" })
    vim.api.nvim_set_hl(0, "TelescopePreviewBorder", { fg = "#424242", bg = "#262626" })
    vim.api.nvim_set_hl(0, "TelescopePromptBorder", { fg = "#424242", bg = "#262626" })
    vim.api.nvim_set_hl(0, "TelescopeResultsBorder", { fg = "#424242", bg = "#262626" })
    vim.api.nvim_set_hl(0, "TelescopePreviewTitle", { fg = "#A1A1A1", bg = "#262626" })
    vim.api.nvim_set_hl(0, "TelescopePromptTitle", { fg = "#A1A1A1", bg = "#262626" })
    vim.api.nvim_set_hl(0, "TelescopeResultsTitle", { fg = "#A1A1A1", bg = "#262626" })
    vim.api.nvim_set_hl(0, "TelescopeSelection", { fg = "#b988b0" })
    vim.api.nvim_set_hl(0, "TelescopeSelectionCaret", { fg = "#b988b0" })
end

