vim.cmd([[ 
    hi Pmenu guibg=#262626 ctermbg=NONE
    hi PmenuSel guibg=#085D96
    hi CmpItemAbbrMatch guifg=#CEDFF2 gui=NONE
    " hi CmpItemAbbrMatch guifg=#D6B981 gui=NONE " yellow
    hi CmpItemAbbr guifg=#8697BA

    hi Visual guibg=#2A56AD gui=NONE
    hi Search guibg=#4A5369 guifg=NONE gui=NONE

    hi Normal guibg=NONE ctermbg=NONE
    hi NormalNC guibg=NONE ctermbg=NONE

    hi StatusLineNC guifg=#566178
    hi StatusLine guifg=#7F8FB0

    hi ColorColumn guibg=#2C2F38
]])

-- Telescope
local ok, telescope = pcall(require, "telescope")
if ok then
    vim.api.nvim_set_hl(0, "TelescopeNormal", { bg = "#262626" })
    vim.api.nvim_set_hl(0, "TelescopePreviewBorder", { fg = "#424242", bg = "#262626" })
    vim.api.nvim_set_hl(0, "TelescopePromptBorder", { fg = "#424242", bg = "#262626" })
    vim.api.nvim_set_hl(0, "TelescopeResultsBorder", { fg = "#424242", bg = "#262626" })
    vim.api.nvim_set_hl(0, "TelescopePreviewTitle", { fg = "#A1A1A1", bg = "#262626" })
    vim.api.nvim_set_hl(0, "TelescopePromptTitle", { fg = "#A1A1A1", bg = "#262626" })
    vim.api.nvim_set_hl(0, "TelescopeResultsTitle", { fg = "#A1A1A1", bg = "#262626" })
    vim.api.nvim_set_hl(0, "TelescopeSelection", { fg = "white", bg = "#353B49" })
    vim.api.nvim_set_hl(0, "TelescopeSelectionCaret", { fg = "#353B49", bg = "#353B49" })
    vim.api.nvim_set_hl(0, "TelescopeMatching", { fg = "#D6B981", bg = "#39404F", bold = false })
end

-- Treesitter
local soft_grey = "#A9B7C6"
local dim_yellow = "#BAB429"
local dark_green = "#6A8759"
local carrot_red = "#CC7832"
local purple = "#9876AA"
local topaz_yellow = "#FFC66D"
local dim_blue = "#6897BB"
vim.api.nvim_set_hl(0, "@attribute", { fg = dim_yellow })
vim.api.nvim_set_hl(0, "@function", { fg = topaz_yellow })
vim.api.nvim_set_hl(0, "@module", { fg = topaz_yellow })
vim.api.nvim_set_hl(0, "@function.method", { fg = soft_grey })
vim.api.nvim_set_hl(0, "@property", { fg = purple })
vim.api.nvim_set_hl(0, "@variable.member", { fg = purple })
vim.api.nvim_set_hl(0, "@variable.parameter", { fg = white })
vim.api.nvim_set_hl(0, "@string", { fg = dark_green })
vim.api.nvim_set_hl(0, "@constant", { fg = purple, italic = true })
vim.api.nvim_set_hl(0, "@constant.builtin", { fg = carrot_red })
vim.api.nvim_set_hl(0, "@keyword", { fg = carrot_red })
vim.api.nvim_set_hl(0, "@type.builtin", { fg = carrot_red })
vim.api.nvim_set_hl(0, "@variable.builtin", { fg = carrot_red })
vim.api.nvim_set_hl(0, "@boolean", { fg = carrot_red })
vim.api.nvim_set_hl(0, "@keyword.repeat", { link = "@keyword" })
vim.api.nvim_set_hl(0, "@keyword.conditional", { link = "@keyword" })
vim.api.nvim_set_hl(0, "@keyword.function", { link = "@keyword" })
vim.api.nvim_set_hl(0, "@keyword.return", { link = "@keyword" })
vim.api.nvim_set_hl(0, "@keyword.import", { link = "@keyword" })
vim.api.nvim_set_hl(0, "@keyword.operator", { link = "@keyword" })
vim.api.nvim_set_hl(0, "@type", { fg = soft_grey })
vim.api.nvim_set_hl(0, "@type.definition", { link = "@type" })
vim.api.nvim_set_hl(0, "@operator", { fg = soft_grey })
vim.api.nvim_set_hl(0, "@punctuation.bracket", { fg = soft_grey })
vim.api.nvim_set_hl(0, "@variable", { fg = soft_grey })
vim.api.nvim_set_hl(0, "@number", { fg = dim_blue })

-- language specific
vim.api.nvim_set_hl(0, "@property.yaml", { fg = carrot_red })
vim.api.nvim_set_hl(0, "@boolean.yaml", { fg = soft_grey })