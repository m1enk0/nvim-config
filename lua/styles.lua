vim.cmd([[ 
    hi Pmenu guibg=NONE guifg=#42424a ctermbg=NONE
    " hi PmenuSel guibg=#085D96
    hi PmenuSel guibg=#113A5C
    hi PmenuSbar guibg=#333333
    hi PmenuThumb guibg=#4A4A4A

    hi CmpItemAbbrMatch guifg=#6897BB gui=NONE
    hi CmpItemAbbrMatchFuzzy guifg=#6897BB gui=NONE
    " hi CmpItemAbbr guifg=#8697BA
    hi CmpItemMenu  guifg=#747982

    hi Visual guibg=#214283 gui=NONE
    hi Search guibg=#4A5369 guifg=NONE gui=NONE

    hi Normal guibg=NONE ctermbg=NONE
    hi NormalNC guibg=NONE ctermbg=NONE

    " hi StatusLineNC guifg=#566178
    hi StatusLine guibg=#323232

    hi ColorColumn guibg=#2E2E2E

    hi NormalFloat guibg=#292929
    hi FloatBorder guifg=#42424a guibg=#2B2B2B

    hi TabLineSel guifg=white

    hi CursorLine guibg=#323232

    hi SpellBad gui=underline cterm=underline
]])

-- Telescope
local ok, telescope = pcall(require, "telescope")
if ok then
    local telescope_bg = "#2E2E2E"
    vim.api.nvim_set_hl(0, "Directory", { link = "Comment" })

    vim.api.nvim_set_hl(0, "TelescopeNormal", { bg = telescope_bg })
    vim.api.nvim_set_hl(0, "TelescopePreviewBorder", { fg = "#424242", bg = telescope_bg })
    vim.api.nvim_set_hl(0, "TelescopePromptBorder", { fg = "#424242", bg = telescope_bg })
    vim.api.nvim_set_hl(0, "TelescopeResultsBorder", { fg = "#424242", bg = telescope_bg })
    vim.api.nvim_set_hl(0, "TelescopePreviewTitle", { fg = "#A1A1A1", bg = telescope_bg })
    vim.api.nvim_set_hl(0, "TelescopePromptTitle", { fg = "#A1A1A1", bg = telescope_bg })
    vim.api.nvim_set_hl(0, "TelescopeResultsTitle", { fg = "#A1A1A1", bg = telescope_bg })
    vim.api.nvim_set_hl(0, "TelescopeSelection", { fg = "white", bg = "#353B49" })
    vim.api.nvim_set_hl(0, "TelescopeSelectionCaret", { fg = "#353B49", bg = "#353B49" })
    vim.api.nvim_set_hl(0, "TelescopeMatching", { bg = "#434D5E", bold = false })
end

-- Treesitter
local soft_grey = "#A9B7C6"
local dim_yellow = "#BAB429"
local dark_green = "#6A8759"
local carrot_red = "#CC7832"
local purple = "#9876AA"
local topaz_yellow = "#FFC66D"
local dim_blue = "#6897BB"
local comment = "#808080"
vim.api.nvim_set_hl(0, "@attribute", { fg = dim_yellow })
vim.api.nvim_set_hl(0, "@function", { fg = topaz_yellow })
vim.api.nvim_set_hl(0, "@module", { fg = topaz_yellow })
vim.api.nvim_set_hl(0, "@function.method", { fg = topaz_yellow })
vim.api.nvim_set_hl(0, "@function.method.call", { fg = soft_grey })
vim.api.nvim_set_hl(0, "@function.builtin", { fg = soft_grey })
vim.api.nvim_set_hl(0, "@class_field", { fg = purple })
vim.api.nvim_set_hl(0, "@property", { fg = purple })
vim.api.nvim_set_hl(0, "@variable.member", { fg = purple })
vim.api.nvim_set_hl(0, "@variable.parameter", { fg = soft_grey })
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
vim.api.nvim_set_hl(0, "@comment", { fg = comment })

-- language specific
vim.api.nvim_set_hl(0, "@property.yaml", { fg = carrot_red })
vim.api.nvim_set_hl(0, "@boolean.yaml", { fg = soft_grey })
vim.api.nvim_set_hl(0, "@lsp.type.operator.cpp", { fg = carrot_red })