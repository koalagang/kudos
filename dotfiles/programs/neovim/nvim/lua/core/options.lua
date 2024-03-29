-- see `:h options` for more options
-- note that neovim has much saner defaults than vim;
-- see `:h nvim-defaults` for those

local options = {

    encoding = "utf-8",
    shiftwidth = 4,
    ignorecase = true,
    undofile = true,

    -- [[local to buffer]]
    swapfile = false,
    tabstop = 4,
    softtabstop = 4,
    expandtab = true,
    autoindent = true,
    smartindent = true,
    spelllang = "en_gb,nb_no",
    textwidth = 120,

    -- [[local to window]]
    number = true,
    relativenumber = true,
    cursorline = true,
    -- permanently enable sign column
    -- this is because I find it annoying for it to open and close all the time
    signcolumn = "yes",

    -- [[global]]
    -- declutter vim screen
    laststatus = 0,
    ruler = false,
    showmode = false,
    showcmd = false,
    shm = "IF",
    -- other global options
    termguicolors = true,
    smartcase = true,
    lazyredraw = true,
    wildmenu = true,
    wildignore = "*.jpg,*.png,*.gif,*.bmp,*.ico,*.pdf,*.a,*.o,*.so,*.pyc,*.git,*.tmp,*.swp",
    wildignorecase = true,
    autowrite = false,
    mousemodel = "extend", -- disable right-click menu
    virtualedit = "block",
    inccommand = "split",
}

for k, v in pairs(options) do
    vim.opt[k] = v
end

-- might re-enable backups and/or swapfiles at some point
vim.g.nobackup = true
vim.g.noswapfile = true
