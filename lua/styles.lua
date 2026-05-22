vim.api.nvim_set_hl(0, 'Pmenu', { bg = "#272726", fg = "#BBBBBB", ctermbg = "NONE" })
vim.api.nvim_set_hl(0, 'PmenuSel', { bg = "#113A5C" })
vim.api.nvim_set_hl(0, 'PmenuSbar', { bg = "#333333" })
vim.api.nvim_set_hl(0, 'PmenuThumb', { bg = "#4A4A4A" })

vim.api.nvim_set_hl(0, 'CmpItemAbbrMatch', { fg = "#5490F5", bold = false })
vim.api.nvim_set_hl(0, 'CmpItemAbbrMatchFuzzy', { fg = "#5490F5", bold = false })
vim.api.nvim_set_hl(0, 'CmpItemMenu', { fg = "#72737A" })

vim.api.nvim_set_hl(0, 'Visual', { bg = "#214283", bold = false })
vim.api.nvim_set_hl(0, 'Search', { bg = "#3B4252", fg = "NONE", bold = false })

vim.api.nvim_set_hl(0, 'Normal', { bg = "NONE", ctermbg = "NONE" })
vim.api.nvim_set_hl(0, 'NormalNC', { bg = "NONE", ctermbg = "NONE" })

vim.api.nvim_set_hl(0, 'StatusLine', { bg = "#323232" })
vim.api.nvim_set_hl(0, 'ColorColumn', { bg = "#2E2E2E" })

vim.api.nvim_set_hl(0, "NormalFloat", { bg = "#292929" })
vim.api.nvim_set_hl(0, "FloatBorder", { fg = "#ffffff", bg = "#292929" })

vim.api.nvim_set_hl(0, 'TabLineSel', { fg = "white" })

vim.api.nvim_set_hl(0, 'CursorLine', { bg = "#323232" })

vim.api.nvim_set_hl(0, 'SpellBad', { underline = true, italic = false })

vim.api.nvim_set_hl(0, 'LineNr', { fg = "#606366" })

-- vim.api.nvim_set_hl(0, 'BlinkCmpLabelMatch', { fg = "#5490F5", bold = false })
vim.api.nvim_set_hl(0, 'BlinkCmpLabelMatch', { bold = true })
vim.api.nvim_set_hl(0, 'PmenuKind', { bg = "NONE", fg = "#72737A" })
vim.api.nvim_set_hl(0, 'PmenuExtra', { fg = "#72737A" })

vim.api.nvim_set_hl(0, 'TabLine', { fg = "#666666", bg = "#222222", italic = false })
vim.api.nvim_set_hl(0, 'TabLineFill', { fg = "#999999", bg = "#1a1a1a", italic = false })
vim.api.nvim_set_hl(0, 'TabLineSel', { fg = "#ffffff", bg = "#2B2B2B", bold = true })

vim.api.nvim_set_hl(0, 'WinSeparator', { fg = "#252628", bg = "#313335" })

vim.api.nvim_set_hl(0, 'DiffAdd', { bg = "#294436" })
vim.api.nvim_set_hl(0, 'DiffDelete', { bg = "#45302B" })

vim.api.nvim_set_hl(0, 'Folded', { fg = "#808080" })

-- vim.api.nvim_set_hl(0, "CurSearch", {})
vim.api.nvim_set_hl(0, "CurSearch", { link = "Search" })

vim.fn.sign_define("DapBreakpoint", { text = "●", texthl = "ErrorMsg", linehl = "", numhl = "" })
vim.fn.sign_define("DapStopped", { linehl = "DapStoppedLine" })
vim.api.nvim_set_hl(0, "DapStoppedLine", { bg = "#3A2323" })

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
    vim.api.nvim_set_hl(0, "TelescopeSelection", { bg = "#353B49" })
    vim.api.nvim_set_hl(0, "TelescopeSelectionCaret", { fg = "#353B49", bg = "#353B49" })
    -- vim.api.nvim_set_hl(0, "TelescopeMatching", { bg = "#434D5E", bold = false })
    vim.api.nvim_set_hl(0, "TelescopeMatching", { bold = true })
end

-- Treesitter
local soft_grey = "#A9B7C6"
local dim_yellow = "#BBB529"
local dark_green = "#6A8759"
local carrot_red = "#CC7832"
local purple = "#9876AA"
local topaz_yellow = "#FFC66D"
local dim_blue = "#6897BB"
local comment = "#808080"
local bright_green = "#629755"
local error_red = "#BC3F3C"
vim.api.nvim_set_hl(0, "@attribute", { fg = dim_yellow })
vim.api.nvim_set_hl(0, "@function", { fg = topaz_yellow })
vim.api.nvim_set_hl(0, "@module", { fg = topaz_yellow })
vim.api.nvim_set_hl(0, "@function.method", { fg = topaz_yellow })
vim.api.nvim_set_hl(0, "@function.method.call", { fg = soft_grey })
vim.api.nvim_set_hl(0, "@function.call", { fg = soft_grey })
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
vim.api.nvim_set_hl(0, "@keyword.exception", { link = "@keyword" })
vim.api.nvim_set_hl(0, "@type", { fg = soft_grey })
vim.api.nvim_set_hl(0, "@type.definition", { link = "@type" })
vim.api.nvim_set_hl(0, "@operator", { fg = soft_grey })
vim.api.nvim_set_hl(0, "@punctuation.bracket", { fg = soft_grey })
vim.api.nvim_set_hl(0, "@variable", { fg = soft_grey })
vim.api.nvim_set_hl(0, "@number", { fg = dim_blue })
vim.api.nvim_set_hl(0, "@comment", { fg = comment })
vim.api.nvim_set_hl(0, "DiagnosticUnderlineError", { fg = error_red })
vim.api.nvim_set_hl(0, "@lsp.typemod.annotation.importDeclaration", { fg = dim_yellow })
vim.api.nvim_set_hl(0, "@lsp.type.method", { fg = soft_grey })
vim.api.nvim_set_hl(0, "@lsp.type.namespace", { fg = soft_grey })
vim.api.nvim_set_hl(0, "@lsp.typemod.method.static", { italic = true })
vim.api.nvim_set_hl(0, "@comment.documentation", { fg = bright_green, italic = true })
vim.api.nvim_set_hl(0, "@lsp.typemod.method.declaration", { fg = topaz_yellow, italic = false })
vim.api.nvim_set_hl(0, "@lsp.type.modifier", { link = "@keyword" })
vim.api.nvim_set_hl(0, "@lsp.typemod.keyword.documentation", { fg = bright_green, bold = true })
vim.api.nvim_set_hl(0, "@lsp.typemod.parameter.documentation", { fg = "#8A653B" })
vim.api.nvim_set_hl(0, "@lsp.typemod.typeParameter.declaration", { fg = "#507874" })
vim.api.nvim_set_hl(0, "@lsp.type.typeParameter", { fg = "#507874" })
vim.api.nvim_set_hl(0, "@lsp.typemod.annotationMember.declaration", { fg = topaz_yellow })
vim.api.nvim_set_hl(0, "@keyword.conditional.ternary", { fg = soft_grey })

-- language specific
vim.api.nvim_set_hl(0, "@property.yaml", { fg = carrot_red })
vim.api.nvim_set_hl(0, "@boolean.yaml", { fg = soft_grey })
vim.api.nvim_set_hl(0, "@punctuation.delimiter.yaml", { fg = soft_grey })
vim.api.nvim_set_hl(0, "@lsp.type.operator.cpp", { fg = carrot_red })
vim.api.nvim_set_hl(0, "@function.groovy", { fg = soft_grey })
vim.api.nvim_set_hl(0, "@lsp.type.annotation.java", { fg = dim_yellow })