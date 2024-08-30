require("markview").setup({
    modes = { "n", "i", "no", "c" },
    hybrid_modes = { "i" },

    headings = {
        enable = true,
        shift_width = 1,
        heading_1 = {
            style = "icon",
            icon = "◉ ",
            sign = "",
            hl = "CursorLine",
        },
        heading_2 = {
            style = "icon",
            icon = "✿ ",
            sign = "",
            hl = "CursorLine",
        },
        heading_3 = {
            style = "icon",
            icon = "✸ ",
            hl = "CursorLine",
        },
        heading_4 = {
            style = "icon",
            icon = "○ ",
            hl = "CursorLine",
        },
        heading_5 = {
            style = "icon",
            icon = "★ ",
            hl = "CursorLine",
        },
        heading_6 = {
            style = "icon",
            icon = "◆ ",
            hl = "CursorLine",
        },
    },
    code_blocks = {
        enable = true,
        style = "language",
        min_width = 25,
        language_direction = "left",
        sign = false,
    },

    -- disable these to let obsidian.nvim handle them instead
    checkboxes = { enable = false },
    list_items = { enable = false },
    links = { enable = false },
});

-- I'm aware that there are plugins like goyo, zen-mode and true-zen
-- but they mess with markview's hybdrid mode,
-- plus using a whole plugin is a bit overkill when this accomplishes what I want.
local options = {
    laststatus = 0,
    ruler = false,
    showcmd = false,
    signcolumn = "yes",
    number = false,
    relativenumber = false,
}
for k, v in pairs(options) do
    vim.opt[k] = v
end
