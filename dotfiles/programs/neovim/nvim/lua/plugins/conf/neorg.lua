require("neorg").setup({
    load = {
        ["core.defaults"] = {},
        ["core.export"] = {},
        ["core.export.markdown"] = {},
        ["core.integrations.treesitter"] = {},
        ["core.concealer"] = {
            config = {
                icon_preset = "varied",
            },
        },
    }
})

-- require("neorg").setup {
--     load = {
--         -- Modules in core.defaults
--         -- Double-comment (i.e. ----) = considering enabling
--         --["core.clipboard.code-blocks"] = {},
--         ["core.esupports.hop"] = {},
--         ["core.esupports.indent"] = {},
--         ["core.esupports.metagen"] = {},
--         ["core.itero"] = {},
--         --["core.journal"] = {},
--         ['core.keybinds'] = {
--             config = {
--                 hook = function(keybinds)
--                     -- depends on nvim-neorg/neorg-telescope
--                     keybinds.map_event('norg', 'n', '<c-t>n', 'core.integrations.telescope.find_linkable')
--                     keybinds.map_event('norg', 'n', '<c-t>h', 'core.integrations.telescope.search_headings')
--                     -- <c-t> is used by core.promo in insert mode
--                     keybinds.map_event('norg', 'i', '<A-n>', 'core.integrations.telescope.insert_link')
--                 end,
--             },
--         },
--         --["core.looking-glass"] = {}, -- will use this if I ever decide to write a literate config, unless I decide to use otter.nvim
--         --["core.pivot"] = {},
--         ["core.promo"] = {},
--         ----["core.qol.toc"] = {},
--         ["core.qol.todo_items"] = {},
--         ----["core.tangle"] = {}, -- will use this if I ever decide to write a literate config
--         --["core.upgrade"] = {},
--
--         -- Add pretty icons to documents
--         ["core.concealer"] = {
--             config = {
--                 icon_preset = "varied",
--             },
--         },
--
--         -- Manage Neorg workspaces
--         ["core.dirman"] = {
--             config = {
--                 workspaces = {
--                     neorg = "$HOME/Documents/neorg",
--
--                     japanese = "$HOME/Documents/neorg/japanese",
--                     misc  = "$HOME/Documents/neorg/misc",
--                     reading = "$HOME/Documents/neorg/reading",
--                     stories = "$HOME/Documents/neorg/stories",
--                     study = "$HOME/Documents/neorg/study",
--                     systems = "$HOME/Documents/neorg/systems",
--                     tech = "$HOME/Documents/neorg/tech",
--                     tasknotes = "$HOME/Documents/neorg/tasknotes" -- Used by taskopen
--                 },
--             -- I don't actually use this workspace directly
--             -- I've only assigned this so that neorg-telescope only searches this directory
--             default_workspace = "neorg",
--             },
--         },
--
--         -- Export norg files to markdown with `:Neorg export to-file filename.md`
--         ["core.export"] = {},
--
--         -- will uncomment once I've set up nvim-cmp
--         --["core.completion"] = {},
--
--         -- Enable telescope integration
--         -- depends on nvim-neorg/neorg-telescope
--         ["core.integrations.telescope"] = {},
--
--         --["core.integrations.treesitter"] = {},
--     },
--
-- }
-- vim.wo.foldlevel = 1
-- vim.wo.conceallevel = 2
--
-- --[[
-- local function imap(shortcut, command)
--     vim.keymap.set("i", shortcut, command)
-- end
-- imap("<m-*>", "**<left>")
-- imap("<m-/>", "//<left>")
-- imap("<m-_>", "__<left>")
-- imap("<m-:>", "{::}<left><left>")
-- ]]
--
-- --[[
-- This can also be done using the keybinds module (see above).
-- However, that makes lazy-loading harder.
-- Binding the command manually
-- and then lazy-loading neorg (see lazy.nvim entry) with <c-t>n allows us to lazy-load neorg-telescope.
-- ]]
-- local function nmap(shortcut, command)
--     vim.keymap.set("n", shortcut, command)
-- end
-- nmap("<c-t>n", "<cmd>Telescope neorg find_linkable<cr>")
