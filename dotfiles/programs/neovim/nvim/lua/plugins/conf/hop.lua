local function map(shortcut, command)
    vim.keymap.set({"n", "v"}, shortcut, command)
end

-- TODO: change mapping from f to something else
-- Also, consider switching to flash.nvim
require("hop").setup({
    map("f", "<cmd>HopWordCurrentLine<cr>"),
    map("F", "<cmd>HopWord<cr>"),
    map("<localleader>1", "<cmd>HopChar1<cr>"),
    map("<localleader>2", "<cmd>HopChar2<cr>"),
    -- change the colour of hints to orange
    vim.cmd("hi HopNextKey guifg=#FFB86C"),
})
