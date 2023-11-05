-- see `:h options` for more options
-- note that neovim has much saner defaults than vim;
-- see `:h nvim-defaults` for those

local options = {

    encoding = "utf-8",
    shiftwidth = 4,
    ignorecase = true,
    undofile = true,

    -- local to buffer,
    swapfile = false,
    tabstop = 4,
    softtabstop = 4,
    expandtab = true,
    autoindent = true,
    smartindent = true,
    spelllang = "en_gb,nb_no",
    textwidth = 120,

    -- local to window,
    number = true,
    relativenumber = true,
    signcolumn = "yes",
    cursorline = true,

    -- global
    laststatus = 3,
    smartcase = true,
    lazyredraw = true,
    wildmenu = true,
    wildignore = "*.jpg,*.png,*.gif,*.bmp,*.ico,*.pdf,*.a,*.o,*.so,*.pyc,*.git,*.tmp,*.swp",
    wildignorecase = true,
    autowrite = false,
    --termguicolors = true,
    mouse = "",
}

for k, v in pairs(options) do
    vim.opt[k] = v
end

vim.g.nobackup = true
vim.g.noswapfile = true
