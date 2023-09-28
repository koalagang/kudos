local telescope = require('telescope')
telescope.setup({
    defaults = {
        layout_strategy = "horizontal",
        layout_config = {
            horizontal = { width = 0.9, height = 0.9 },
        },
        mappings = {
            i = {
                -- map actions.which_key to <C-h> (default: <C-/>)
                -- actions.which_key shows the mappings for your picker,
                -- e.g. git_{create, delete, ...}_branch for the git_branches picker
                ["<C-h>"] = "which_key",
                ["<C-j>"] = "move_selection_next",
                ["<C-k>"] = "move_selection_previous",
            },
        },
    },
    pickers = {
        -- Default configuration for builtin pickers goes here:
        -- picker_name = {
        --   picker_config_key = value,
        --   ...
        -- }
        -- Now the picker_config_key will be applied every time you call this
        -- builtin picker
    },
    extensions = {
        -- Your extension configuration goes here:
        -- extension_name = {
        --   extension_config_key = value,
        -- }
        -- please take a look at the readme of the extension you want to configure
    },
})
telescope.load_extension("fzf") -- nvim-telescope/telescope-fzf-native.nvim
-- TODO: telescope-zoxide; other extensions too?
-- perhaps AckslD/nvim-neoclip.lua
-- stevearc/dressing.nvim or telescope-ui-select.nvim?
