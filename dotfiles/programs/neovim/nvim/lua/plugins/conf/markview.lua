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
