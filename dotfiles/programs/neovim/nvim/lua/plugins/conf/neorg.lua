require("neorg").setup {
    load = {
        -- Loads default behaviour
        -- Once I get used to using neorg, I will be more specific and remove default modules that I don't use
        ["core.defaults"] = {},

        -- Adds pretty icons to your documents
        ["core.concealer"] = {
            config = {
                icon_preset = "varied",
            },
        },

        -- Manages Neorg workspaces
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
        ["core.export"] = {},

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

local neorg_callbacks = require("neorg.core.callbacks")
neorg_callbacks.on_event("core.keybinds.events.enable_keybinds", function(_, keybinds)
    -- Map all the below keybinds only when the "norg" mode is active
    keybinds.map_event_to_mode("norg", {
        n = { -- Bind keys in normal mode
            { "TN", "core.integrations.telescope.find_linkable" },
            -- depends on nvim-neorg/neorg-telescope
        },

        i = { -- Bind in insert mode
            { "TN", "core.integrations.telescope.insert_link" },
            -- depends on nvim-neorg/neorg-telescope
        },
    }, {
        silent = true,
        noremap = true,
    })
end)
