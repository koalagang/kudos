--[[
-- disable built-in plugins
local disabled_built_ins = {
    "remote_plugins",
    "spec",
    "netrw",
    "netrwPlugin",
    "netrwSettings",
    "netrwFileHandlers",
    "gzip",
    "zip",
    "zipPlugin",
    "tar",
    "tarPlugin",
    "getscript",
    "getscriptPlugin",
    "vimball",
    "vimballPlugin",
    "2html_plugin",
    "logipat",
    "rrhelper",
    "spellfile_plugin",
    "matchit",
    --"health",
    --"man",
    "matchparen",
    "rplugin",
    "shada",
    "shada_plugin",
    "spellfile",
    "tohtml",
    "tutor",
    "tutor_mode_plugin",
}
for _, plugin in pairs(disabled_built_ins) do
    vim.g["loaded_" .. plugin] = 0
end
]]

require('core')
require('plugins')
