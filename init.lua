local vimrc = "~/.vimrc"
vim.cmd("source " .. vimrc)

require("bootstrap_lazy")

require("keymaps")
require("options")
require("styles")
