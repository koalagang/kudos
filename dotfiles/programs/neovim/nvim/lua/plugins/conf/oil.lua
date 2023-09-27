require("oil").setup({
    -- depends on trash-cli
    delete_to_trash = true,
    trash_command = "trash-put",

    use_default_keymaps = false,
    keymaps = {
        ["g?"] = "actions.show_help",
        ["<CR>"] = "actions.select",
        ["V"] = "actions.select_vsplit",
        ["H"] = "actions.select_split",
        ["<C-t>"] = "actions.select_tab",
        ["<C-p>"] = "actions.preview",
        ["<C-c>"] = "actions.close",
        --["<C-l>"] = "actions.refresh",
        ["-"] = "actions.parent",
        ["_"] = "actions.open_cwd",
        ["`"] = "actions.cd",
        ["~"] = "actions.tcd",
        ["gs"] = "actions.change_sort",
        ["g."] = "actions.toggle_hidden",
    },
})
vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory in current buffer" })
vim.keymap.set("n", "<C-n>", "<CMD>topleft vsplit | Oil<CR>", { desc = "Open parent directory in current buffer" })
