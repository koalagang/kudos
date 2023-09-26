-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Filetypes for treesitter and LSP to lazy-load
local languages = { "sh", "bib", "tex", "make", "rust", "toml", "lua", "nix" }

-- Set plugin config path in a variable in case I decide to move them
local conf = "plugins.conf."

--[[
Despite using homemanager which does actually allow me to install neovim plugins with nix
I like using lazy because:
    -- a) it provides a nice interface
    -- b) it makes setting up lazy-loading far easier
    -- c) whilst I do enjoy nix, I also really like lua
]]
require("lazy").setup({
    -- [[ RULES ]]
    -- Lazy load (almost) everything
    -- If a configuration is longer than two lines, put it in its own file
    -- Be declarative:
        -- just because you specified a plugin somewhere else in the file
        -- doesn't mean you don't need to specify it as a dependency elsewhere
        -- leave a comment regarding external dependencies where applicable
    -- Document everything (excluding obvious things); comments exist for a reason
    -- Try to avoid going overboard on the number of plugins
        -- I'm thinking like 30 plugins- or 40 at the max (excluding dependencies and smaller plugin extensions)

    -- [[ TO INSTALL ]]
    -- DEFINITELY
        -- neovim/nvim-lspconfig
            -- and williamboman/mason.nvim?
            -- I'm considering using `programs.neovim.extraPackages` in homemanager instead of mason
        -- hrsh7th/nvim-cmp
        -- lewis6991/gitsigns.nvim
        -- NeogitOrg/neogit
        -- sindrets/diffview.nvim
        -- pwntester/octo.nvim
        -- L3MON4D3/LuaSnip
            -- write your own snippets in lua
        -- ekickx/clipboard.nvim
            -- configure it to support norg syntax
        -- nvim-focus/focus.nvim
        -- mfussenegger/nvim-dap
        -- ledger/vim-ledger
        -- stevearc/conform.nvim
        -- mfussenegger/nvim-lint
    -- + related extensions (for nvim-cmp, telescope, neorg)
    -- MAYBE
        -- nvim-neotest/neotest
        -- kevinhwang91/nvim-ufo
        -- chentoast/marks.nvim
        -- mracos/mermaid.vim
        -- folke/todo-comments.nvim
        -- folke/trouble.nvim
        -- iamcco/markdown-preview.nvim
        -- junegunn/goyo.vim and junegunn/limelight.vim
            -- or pocco81/true-zen.nvim
            -- or folke/zen-mode.nvim
        -- karb94/neoscroll.nvim


    -- [[ Major plugins ]]
    -- These are the real game-changers
    { -- Treesitter syntax highlighting
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate", -- Check for updates to the parsers
        --dependencies = { "HiPhish/nvim-ts-rainbow2", "nvim-treesitter/nvim-treesitter-textobjects" },
        -- EXTERNAL: tar, curl, gcc
        -- This weird-looking code is simply a way of inserting the languages table
        -- into the ft table alongside norg and markdown
        ft = { [ languages ] = {} , "norg", "markdown" },
        config = function()
            require(conf .. "treesitter")
        end,
    },
    {
        "HiPhish/nvim-ts-rainbow2",
        ft = languages,
        dependencies = "nvim-treesitter/nvim-treesitter",
    },

    { -- "An Organized Future"
      -- NOTE: sometimes neorg's folds break
      -- However, refreshing the file with ':e' fixes this
        "nvim-neorg/neorg",
        build = ":Neorg sync-parsers",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-treesitter/nvim-treesitter",
            {
                "nvim-neorg/neorg-telescope",
                dependencies = { "nvim-telescope/telescope.nvim" },
            },
            -- can't get image.nvim to work
            --"3rd/image.nvim", -- EXTERNAL: magick (luarock), imagemagick, curl
        },
        cmd = "Neorg",
        ft = "norg",
        --[[ NOTE:
        Neorg is *by far* my slowest plugin.
        On my system, Neorg alone takes ~140ms to load when loading via cmd and ~250ms when loading via ft.
        Therefore, for maximum speed, I recommend loading it once and then using telescope or oil to move between files
        (as opposed to closing Neovim and opening a new norg file from the commandline)
        because then Neorg stays loaded until you exit Neovim.
        My config uses '<c-x>' in normal mode to navigate the Neorg workspaces with telescope and '-' or '<c-n>' for oil.
        However, you must first load Neorg before using the former (either by opening a norg file or with ':Neorg').
        ]]
        config = function()
            require(conf .. "neorg")
        end,
    },

    { -- "Neovim file explorer: edit your filesystem like a buffer"
        "stevearc/oil.nvim",
        keys = { "-", "<C-n>" },
        dependencies = { "nvim-tree/nvim-web-devicons" },
        config = function()
            require(conf .. "oil")
        end
    },

    { -- "Neovim motions on speed!"
        "phaazon/hop.nvim",
        branch = "v2",
        keys = { "f", "F", "<localleader>1", "<localleader>2" },
        config = function()
            require(conf .. "hop")
        end,
    },

    { -- "Find, Filter, Preview, Pick. All lua, all the time."
        'nvim-telescope/telescope.nvim',
        branch = '0.1.x',
        cmd = "Telescope",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-tree/nvim-web-devicons", -- EXTERNAL: any nerdfont (I use Fira Code)
            { "nvim-telescope/telescope-fzf-native.nvim", build = 'make' }, -- EXTERNAL: gnumake, gcc
        },
        config = function()
            require(conf .. "telescope")
        end,
    },

    -- [[ Minor plugins ]]
    -- These don't massively change how Neovim behaves but they are really nice to have
    { -- Dracula colourscheme
        "Mofiqul/dracula.nvim",
        -- One of the few plugins I don't lazy-load
        -- High priority to make sure the colourscheme is loaded before everything else
        priority = 1000,
        config = function()
            require(conf .. "dracula")
        end,
    },

    { -- Preview hex colours
        "norcalli/nvim-colorizer.lua",
        cmd = "ColorizerToggle",
        config = function()
            vim.g.termguicolors = true,
            require("colorizer").setup()
        end,
    },

    { -- Indentation line-guides
        "lukas-reineke/indent-blankline.nvim",
        dependencies = "nvim-treesitter/nvim-treesitter",
        ft = languages,
        config = function()
            require(conf .. "indent-blankline")
        end,
    },

    { -- Makes creating markdown tables not pure suffering
        "dhruvasagar/vim-table-mode",
        cmd = "TableModeEnable",
    },

})
