local vimrc = "~/.vimrc"
vim.cmd("source " .. vimrc)

require("keymaps")
require("options")
require("styles")

require("custom")
