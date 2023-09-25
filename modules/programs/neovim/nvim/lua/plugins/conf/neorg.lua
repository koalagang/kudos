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
                    japanese = "$HOME/Documents/japanese",
                    misc  = "$HOME/Documents/misc",
                    reading = "$HOME/Documents/reading",
                    stories = "$HOME/Documents/stories",
                    study = "$HOME/Documents/study",
                    systems = "$HOME/Documents/systems",
                    tech = "$HOME/Documents/tech",
                },
            },
        },

        -- Export norg files to markdown with `:Neorg export to-file filename.md`
        ["core.export"] = {},

        -- will uncomment once I've set up nvim-cmp
        --["core.completion"] = {},
    },

}
vim.wo.foldlevel = 2
vim.wo.conceallevel = 2

local function imap(shortcut, command)
    vim.keymap.set("i", shortcut, command)
end
imap("<m-*>", "**<left>")
imap("<m-/>", "//<left>")
imap("<m-_>", "__<left>")
imap("<m-:>", "::<left>")
vim.cmd("iabbrev <buffer> --- –")
