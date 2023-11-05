-- disable built-in plugins to speed up startup time
-- it only makes a difference of a couple milliseconds but you may as well disable them if you don't use them
-- I've commented out the ones I use, i.e. don't disable them
local disabled_built_ins = {
    "2html_plugin",
    "getscript",
    "getscriptPlugin",
    "gzip",
    --"health",
    "logipat",
    --"man",
    "matchit",
    "matchparen",
    "netrw", -- my file explorer of choice is stevearc/oil.nvim
    "netrwFileHandlers",
    "netrwPlugin",
    "netrwSettings",
    "remote_plugins",
    "rplugin",
    "rrhelper",
    "shada",
    "shada_plugin",
    "spec",
    --"spellfile",
    --"spellfile_plugin",
    "tar",
    "tarPlugin",
    "tohtml",
    "tutor",
    "tutor_mode_plugin",
    "vimball",
    "vimballPlugin",
    "zip",
    "zipPlugin",
}
for _, plugin in pairs(disabled_built_ins) do
    vim.g["loaded_" .. plugin] = 0
end

require('core')
require('plugins')
