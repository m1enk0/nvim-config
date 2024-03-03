local vimrc = "~/.vimrc"
vim.cmd("source " .. vimrc)

require("bootstrap_lazy")
require("lazy").setup("plugins")

require("keymaps")
require("options")
