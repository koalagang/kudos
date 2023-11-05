require("winshift").setup()

local function nmap(shortcut, command)
    vim.keymap.set("n", shortcut, command)
end
-- Move windows around with alt+shift+letter
nmap("<M-H>", "<Cmd>WinShift left<CR>")
nmap("<M-J>", "<Cmd>WinShift down<CR>")
nmap("<M-K>", "<Cmd>WinShift up<CR>")
nmap("<M-L>", "<Cmd>WinShift right<CR>")
