local vimrc = "~/.vimrc"
vim.cmd("source " .. vimrc)

require("bootstrap_lazy")

require("project_settings").load_settings()

-- nvim --cmd "lua init_debug=true"
if init_debug then
    require "osv".launch({ port = 8086, blocking = true })
end

require("global")
require("keymaps")
require("options")
require("styles")

require("custom")
