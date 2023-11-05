require("catppuccin").setup({
    flavour = "mocha",
    dim_inactive = {
        enabled = true, -- dims the background color of inactive window
        shade = "dark",
        percentage = 0.1, -- percentage of the shade to apply to the inactive window
    },
    styles = { -- Handles the styles of general hi groups (see `:h highlight-args`):
        comments = { "italic" }, -- Change the style of comments
        conditionals = { "italic" },
        loops = {},
        functions = {},
        keywords = {},
        strings = {},
        variables = {},
        numbers = {},
        booleans = {},
        properties = {},
        types = {},
        operators = {},
    },
    color_overrides = {},
    custom_highlights = {},
    integrations = {
        cmp = true,
        gitsigns = true,
        treesitter = true,
        hop = true,
        indent_blankline = true,
        telescope = {
            enabled = true,
        },
        --lualine?
        --mason?
        --neogit
        --nvim-dap
        --lspconfig
        --octo

        -- Set to true by default but I don't use them
        nvimtree = false,
        notify = false,
        mini = {
            enabled = false,
            indentscope_color = "",
        },
        -- For more plugin integrations see https://github.com/catppuccin/nvim#integrations
    },
})

-- setup must be called before loading
vim.cmd.colorscheme "catppuccin"
