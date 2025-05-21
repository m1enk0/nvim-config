local vimrc = "~/.vimrc"
vim.cmd("source " .. vimrc)

require("bootstrap_lazy")

require("keymaps")
require("options")
require("styles")

require("compare_clip")
require("execute_param_query")
require("execute_to_split")
