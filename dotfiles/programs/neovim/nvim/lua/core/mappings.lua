-- [[ Functions ]]
local function nmap(shortcut, command)
    vim.keymap.set("n", shortcut, command)
end

local function vmap(shortcut, command)
    vim.keymap.set("v", shortcut, command)
end

local function imap(shortcut, command)
    vim.keymap.set("i", shortcut, command)
end

-- The vim leader key.
-- It's vim's master modifier -- like the superkey of your text editor.
-- It is only used for very special mappings.
vim.g.mapleader = " "
-- Not many people know of it but leader also has a little brother called localleader.
-- It serves a similar purpose but is used less often.
vim.g.localleader = '\\' -- Double-backslash used to escape it

-- [[ Basics ]]
-- Basic bindings
nmap("<c-s>", "<cmd>w<cr>")
nmap(",", "<cmd>noh<cr>")
nmap("cc", "<cmd>set cursorcolumn!<cr>")
vmap("<", "<gv")
vmap(">", ">gv")
nmap("n", "nzzzv")
nmap("N", "Nzzzv")
-- Swap redo and replace around
nmap("r", "<c-r>")
nmap("<c-r>", "r")
-- Find and replace
nmap("S", ":%s//g<left><left>")
vmap("S", ":s/\\%V/g<left><left>")

-- [[ Navigate multiple files ]]
-- Tabs
--nmap("<Tab>", "gt")
--nmap("<S-Tab>", "gT")
--nmap("<c-t>", "<cmd>tabnew<cr>")
--nmap("tf", "tabfind<space>")

-- [[ Surround ]]
-- foot terminal seems to have issues with ctl+shift+character
-- will probably switch to nvim-surround
--imap('<m-">', '""<left>')
imap("<m-2>", '""<left>')
imap("<m-'>", "''<left>")
--imap("<m-(>", "()<left>")
imap("<m-9>", "()<left>")
imap("<m-[>", "[]<left>")
--imap("<m-{>", "{}<left>")
imap("<m-]>", "{}<left>")
--imap("<m-<>", "<><left>")
imap("<c-.>", "<><left>")
imap("<m-`>", "``<left>")

-- [[ Misc ]]
-- Navigate using HJKL in insert mode (while holding down ctrl)
imap("<c-h>", "<left>")
imap("<c-j>", "<down>")
imap("<c-k>", "<up>")
imap("<c-l>", "<right>")

-- [[ Registers ]]
-- Yanking to system clipboard
-- NOTE: as ctrl-v has been remapped, use ctrl-q instead if you wish to enter visual block mode
-- EXTERNAL DEPENDENCY: xclip or xsel (X11), wl-clipboard (wayland)
vmap("<c-c>", '"+y')
vmap("<c-x>", '"+d')
nmap("<c-c>", '"+yy')
nmap("<c-v>", '"+p')
nmap("<c-x>", '"+dd')
vmap("y", '"ay')
vmap("d", '"ad')

-- [[ Other shortcuts/remaps ]]
nmap("<leader>ss", "<cmd>set spell!<cr>") -- spellcheck
nmap("gA", "GA")
nmap("gI", "ggI")
nmap("K", "kddpkJ")
nmap("cD", "Da")
nmap("<cr>", "<cmd>bn<cr>") -- backspace to go to next buffer
nmap("<bs>", "<cmd>bp<cr>") -- return to go to previous buffer
nmap("<tab>", "za") -- tab to toggle currently selected fold
nmap("Q", "V}gqkA<space>")

-- Scripts and other external software
-- Might move this to another file --
nmap("<leader>c", ':w! | !compiler "<c-r>%"<cr><cr>')
nmap("<leader>sc", "<cmd>w! | <cmd>!shellcheck %<cr>")
nmap("<leader>z", "<cmd>!zathura --fork %:t:r.pdf<cr><cr>")

nmap("<localleader>Nw", ":Neorg workspace<space>")
