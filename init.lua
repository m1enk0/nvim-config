local vimrc = "~/.vimrc"
vim.cmd("source " .. vimrc)

require("bootstrap_lazy")

require("global")
require("keymaps")
require("options")
require("styles")

require("custom")
