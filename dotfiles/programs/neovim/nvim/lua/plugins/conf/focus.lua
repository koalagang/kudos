require("focus").setup({
    -- Create blank buffer for new split windows
    split = { bufnew = true, },

    ui = {
        number = true, -- Display line numbers in the focussed window only
        relativenumber = true, -- Display relative line numbers in the focussed window only
        hybridnumber = true, -- Display hybrid line numbers in the focussed window only
    }
})

local function nmap(shortcut, command)
    vim.keymap.set("n", shortcut, command)
end

nmap("<c-h>", "<cmd>FocusSplitLeft<cr>")
nmap("<c-j>", "<cmd>FocusSplitDown<cr>")
nmap("<c-k>", "<cmd>FocusSplitUp<cr>")
nmap("<c-l>", "<cmd>FocusSplitRight<cr>")

-- Open oil in new splits
-- Depends on stevearc/oil.nvim
nmap("<localleader>h", "<cmd>FocusSplitLeft<cr><cmd>Oil<cr>")
nmap("<localleader>j", "<cmd>FocusSplitDown<cr><cmd>Oil<cr>")
nmap("<localleader>k", "<cmd>FocusSplitUp<cr><cmd>Oil<cr>")
nmap("<localleader>l", "<cmd>FocusSplitRight<cr><cmd>Oil<cr>")
