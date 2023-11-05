require("oil").setup({
    -- depends on trash-cli
    delete_to_trash = true,
    trash_command = "trash-put",

    use_default_keymaps = false,
    keymaps = {
        ["g?"] = "actions.show_help",
        ["<cr>"] = "actions.select",
        ["V"] = "actions.select_vsplit",
        ["H"] = "actions.select_split",
        ["<c-p>"] = "actions.preview",
        ["q"] = "actions.close",
        ["-"] = "actions.parent",
        ["_"] = "actions.open_cwd",
        ["`"] = "actions.cd",
        ["~"] = "actions.tcd",
        ["g."] = "actions.toggle_hidden",
        ["gx"] = "actions.open_external",
    },
})
vim.keymap.set("n", "-", "<cmd>Oil --float<cr>", { desc = "Open parent directory in current buffer" })
