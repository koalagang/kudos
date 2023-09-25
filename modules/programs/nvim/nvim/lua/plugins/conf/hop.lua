local function map(shortcut, command)
    vim.keymap.set({"n", "v"}, shortcut, command)
end

require("hop").setup({
    map("f", "<cmd>HopWordCurrentLine<cr>"),
    map("F", "<cmd>HopWord<cr>"),
    map("<localleader>1", "<cmd>HopChar1<cr>"),
    map("<localleader>2", "<cmd>HopChar2<cr>"),
    -- change the colour of hints to orange
    vim.cmd("hi HopNextKey guifg=#FFB86C"),
})
