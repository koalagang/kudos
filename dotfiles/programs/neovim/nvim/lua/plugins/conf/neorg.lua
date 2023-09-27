require("neorg").setup {
    load = {
        -- Modules in core.defaults
        -- Double-comment = considering enabling
        --["core.clipboard.code-blocks"] = {},
        ["core.esupports.hop"] = {},
        ["core.esupports.indent"] = {},
        ["core.esupports.metagen"] = {},
        ["core.itero"] = {},
        --["core.journal"] = {},
        ["core.keybinds"] = {},
        ['core.keybinds'] = {
            config = {
                hook = function(keybinds)
                    -- depends on nvim-neorg/neorg-telescope
                    keybinds.map_event('norg', 'n', '<C-x>', 'core.integrations.telescope.find_linkable')
                    keybinds.map_event('norg', 'i', '<C-x>', 'core.integrations.telescope.insert_link')
                end,
            },
        },
        --["core.looking-glass"] = {},
        --["core.pivot"] = {},
        ["core.promo"] = {},
        ----["core.qol.toc"] = {},
        ["core.qol.todo_items"] = {},
        --["core.tangle"] = {},
        --["core.upgrade"] = {},

        -- Add pretty icons to your documents
        ["core.concealer"] = {
            config = {
                icon_preset = "varied",
            },
        },

        -- Manage Neorg workspaces
        ["core.dirman"] = {
            config = {
                workspaces = {
                    neorg = "$HOME/Documents/neorg",

                    japanese = "$HOME/Documents/neorg/japanese",
                    misc  = "$HOME/Documents/neorg/misc",
                    reading = "$HOME/Documents/neorg/reading",
                    stories = "$HOME/Documents/neorg/stories",
                    study = "$HOME/Documents/neorg/study",
                    systems = "$HOME/Documents/neorg/systems",
                    tech = "$HOME/Documents/neorg/tech",
                },
            -- I don't actually use this workspace directly
            -- I've only assigned this so that neorg-telescope only searches this directory
            default_workspace = "neorg",
            },
        },

        -- Export norg files to markdown with `:Neorg export to-file filename.md`
        --["core.export"] = {},

        -- will uncomment once I've set up nvim-cmp
        --["core.completion"] = {},

        -- Enable telescope integration
        -- depends on nvim-neorg/neorg-telescope
        ["core.integrations.telescope"] = {},

        --["core.integrations.treesitter"] = {},
    },

}
vim.wo.foldlevel = 1
vim.wo.conceallevel = 2

local function imap(shortcut, command)
    vim.keymap.set("i", shortcut, command)
end
imap("<m-*>", "**<left>")
imap("<m-/>", "//<left>")
imap("<m-_>", "__<left>")
imap("<m-:>", "{::}<left><left>")
