-- Bootstrap lazy.nvim
-- EXTERNAL dependency: git
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

vim.keymap.set("n", "<leader>l", "<cmd>Lazy<cr>")
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

    -- [[ BADGES ]]
    -- Plugin dependencies marked with '[N]' comments are not actually dependencies
        -- I've just marked them as dependencies so that they load when their "dependents" loads
    -- My absolute favourite plugins are marked with <3

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
        -- ekickx/clipboard-image.nvim
            -- configure it to support norg syntax
        -- mfussenegger/nvim-dap
        -- null-ls replacement
            -- stevearc/conform.nvim and mfussenegger/nvim-lint
            -- or nvimtools/none-ls.nvim? (probably this)
        -- jghauser/papis.nvim
        -- ledger/vim-ledger
        -- direnv/direnv.vim
    -- + related extensions (for nvim-cmp, telescope, neorg)
    -- MAYBE
        -- nvim-neotest/neotest
        -- kevinhwang91/nvim-ufo
        -- mracos/mermaid.vim
        -- folke/todo-comments.nvim
        -- folke/trouble.nvim
        -- iamcco/markdown-preview.nvim
        -- junegunn/goyo.vim
            -- or pocco81/true-zen.nvim
            -- or folke/zen-mode.nvim
        --  junegunn/limelight.vim
            -- or folke/twilight.nvim
        -- Zeioth/compiler.nvim
        -- Zeioth/dooku.nvim
        -- Bekaboo/deadcolumn.nvim


    ---- [[ MAJOR PLUGINS ]] ----
    -- These are the real game-changers

    -- [[ LSP ]]
    {
        "neovim/nvim-lspconfig",
        ft = languages,
        config = function()
            require(conf .. "lsp")
        end,
    },

    -- [[ Treesitter and extensions ]]
    {
        "nvim-treesitter/nvim-treesitter", -- <3
        build = ":TSUpdate", -- Check for updates to the parsers
        --dependencies = { "nvim-treesitter/nvim-treesitter-textobjects" },
        -- EXTERNAL: tar, curl, gcc
        -- The weird-looking line below is simply a way of inserting the languages table
        -- into the ft table alongside norg and markdown
        ft = { [ languages ] = {} , "norg", "markdown" },
        config = function()
            require(conf .. "treesitter")
        end,
    },
    {
        "HiPhish/rainbow-delimiters.nvim",
        ft = languages,
        dependencies = "nvim-treesitter/nvim-treesitter",
    },
    { -- Split/join blocks of code
         "Wansmer/treesj",
         keys = { "tsj" },
         dependencies = { "nvim-treesitter/nvim-treesitter" },
         config = function()
            require("treesj").setup()
            vim.keymap.set("n", "tsj", "<cmd>TSJToggle<cr>")
         end,
    },

    { -- "An Organized Future"
      -- NOTE: sometimes neorg's folds break
      -- However, refreshing the file with ':e' fixes this
      -- In my experience, though, this seems to have been fixed recently
        "nvim-neorg/neorg", -- <3
        build = ":Neorg sync-parsers",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-treesitter/nvim-treesitter",
            {
                "nvim-neorg/neorg-telescope",
                dependencies = { "nvim-telescope/telescope.nvim" },
                --config = function()
                --    vim.wo.foldlevel = 99
                --end,
            },
        },
        cmd = "Neorg",
        ft = "norg",
        keys = "<c-t>n", -- for use with neorg-telescope
        config = function()
            require(conf .. "neorg")
        end,
    },

    { -- "Neovim motions on speed!"
        "phaazon/hop.nvim",
        branch = "v2",
        keys = { "f", "F", "<localleader>1", "<localleader>2" },
        config = function()
            require(conf .. "hop")
        end,
    },

    { -- "Neovim file explorer: edit your filesystem like a buffer"
        "stevearc/oil.nvim", -- <3
        keys = { "-" },
        cmd = "Oil",
        dependencies = { "nvim-tree/nvim-web-devicons" }, -- EXTERNAL: any nerdfont
        -- EXTERNAL: trash-cli (for trash feature)
        config = function()
            require(conf .. "oil")
        end
    },

    -- [[ Treesitter and extensions ]]
    { -- "Find, Filter, Preview, Pick. All lua, all the time."
        "nvim-telescope/telescope.nvim", -- <3
        branch = "0.1.x",
        cmd = "Telescope",
        keys = { "<c-t>", "<c-g>" },
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-tree/nvim-web-devicons", -- EXTERNAL: any nerdfont
            { "nvim-telescope/telescope-fzf-native.nvim", build = "make" }, -- EXTERNAL: gnumake, gcc
        },
        config = function()
            require(conf .. "telescope")
        end,
    },
    {
        "jvgrootveld/telescope-zoxide",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-telescope/telescope.nvim",
            "stevearc/oil.nvim", -- [N]
        },
        -- EXTERNAL: zoxide
        keys = "<c-t>z",
        config = function()
            vim.keymap.set("n", "<c-t>z", require("telescope").extensions.zoxide.list)
        end,
    },

    -- Using a tiling window manager is great and all
    -- but when you open vim instances in many separate terminals,
    -- interaction between these buffers is limited.
    -- The solution is splits, which are essentially vim windows tiling inside a single instance.
    -- But that just introduces another problem -- splits are an absolute pain to work with in vanilla vim.
    -- Enter focus and winshift!
    -- This beautiful duo makes using splits an actual comfortable experience.
    { -- Auto-focusing and auto-resizing splits/windows
        "nvim-focus/focus.nvim", -- <3
        version = "*",
        keys = { "<c-h>", "<c-j>", "<c-k>", "<c-l>", "<localleader>h", "<localleader>j", "<localleader>k", "<localleader>l" },
        config = function()
            require(conf .. "focus")
        end,
    },
    { -- Rearrange your windows with ease
        "sindrets/winshift.nvim",
        keys = { "<M-H>", "<M-J>", "<M-K>", "<M-L>" },
        config = function()
            require(conf .. "winshift")
        end,
    },
    -- Once I've also setup toggleterm, gitsigns, neogit and octo, I'll have no excuse to leave neovim.
    -- focus, winshift, oil and telescope will allow me to navigate files with ease,
    -- gitsigns, neogit and octo will reduce (or even remove?) the need for using the commandline to interactive with git
    -- and if I still find myself needing to use the commandline alongside neovim, toggleterm will be right there.

    { -- Visualises the undo history and makes it easy to browse and switch between different undo branches
      -- Not to be confused with mbbill/undotree (which does mostly the same thing)
        "jiaoshijie/undotree",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-focus/focus.nvim", -- [N]
        },
        keys = { "<leader>u" },
        config = function()
            require("undotree").setup()
            vim.keymap.set("n", "<leader>u", require("undotree").toggle, { noremap = true, silent = true })
        end,
    },

    { -- "A snazzy bufferline for Neovim"
        "akinsho/bufferline.nvim",
        version = "*",
        dependencies = "nvim-tree/nvim-web-devicons",
        -- Load only after adding another buffer to the buffer list
        event = "BufAdd",
        config = function()
            require(conf .. "bufferline")
        end,
    },

    ---- [[ MINOR PLUGINS ]] ----
    -- These don't massively change how Neovim behaves but they are really nice to have

    --{ -- Dracula colourscheme
    --    "Mofiqul/dracula.nvim",
    --    -- One of the few plugins I don't lazy-load
    --    -- High priority to make sure the colourscheme is loaded before everything else
    --    priority = 1000,
    --    --config = function()
    --    --    require(conf .. "dracula")
    --    --end,
    --},
    {
        "catppuccin/nvim", -- <3
        name = "catppuccin",
        -- One of the few plugins I don't lazy-load
        lazy = false,
        -- High priority to make sure the colourscheme is loaded before everything else
        priority = 1000,
        config = function()
            require(conf .. "catppuccin")
        end,
    },

    { -- Preview hex colours
        "norcalli/nvim-colorizer.lua",
        cmd = "ColorizerToggle",
        config = function()
            require("colorizer").setup()
        end,
    },

    { -- Indentation line-guides
        "lukas-reineke/indent-blankline.nvim",
        main = "ibl",
        dependencies = { "nvim-treesitter/nvim-treesitter", "HiPhish/rainbow-delimiters.nvim" },
        ft = languages,
        config = function()
            require(conf .. "indent-blankline")
        end,
    },

    { -- Bringing images to Neovim
        "3rd/image.nvim",
        ft = { "norg", "markdown" },
        dependencies = "nvim-treesitter/nvim-treesitter",
        -- EXTERNAL: magick (luarock), imagemagick, curl
        config = function()
            require(conf .. "image")
        end,
    },

    ---- [[ EASING PLUGINS ]] ---
    -- These are very simple plugins that just make life easier.
    -- I suppose winshift and focus could go here
    -- but I think those make a big enough difference that I categorise them as 'major plugins'.

    { -- Makes moving lines and words easier
        "fedepujol/move.nvim",
        keys = { "<A-h>", "<A-j>", "<A-k>", "<A-l>", },
        config = function()
            require(conf .. "move")
        end,
    },

    { -- Makes creating markdown tables not pure suffering
        "dhruvasagar/vim-table-mode",
        cmd = "TableModeToggle",
    },

    { -- Align text
      -- by selecting it in visual block mode
      -- and hitting <leader>a followed by your character to align to
        "Vonr/align.nvim",
        branch = "v2",
        keys = {{ "<leader>a", mode = "v" }},
        config = function()
            vim.keymap.set(
                'v',
                '<leader>a',
                function()
                    require'align'.align_to_string({
                        preview = true,
                    })
                end,
                { noremap = true, silent = true }
            )
        end,
    },

    { -- "A better user experience for viewing and interacting with Vim marks"
        "chentoast/marks.nvim",
        keys = { "m", "dm", "m,", "m;", "dmx", "dm-", "dm<space>", "m]", "m[", "m:", "m}", "m{", "dm=" },
        config = function()
            require("marks").setup()
        end,
        -- TIP: if like me, you're having issues where marks persist
        -- even when you delete them, run :delmarks A-Z0-9 and then :wshada! to permanently clear them.
        -- See https://github.com/neovim/neovim/issues/7198#issuecomment-323649157
        -- I'm not sure if is relevant to marks.nvim but
        -- I hadn't noticed this before because I didn't use marks prior to this plugin
    },

    {
        "ledger/vim-ledger",
        ft = { "ledger", "journal" },
        config = function()
            -- set tabs to two spaces
            vim.opt.tabstop = 2
            vim.opt.softtabstop = 2
            vim.opt.shiftwidth = 2
        end,
    },

    -- TESTING
    --[[

    {
        "kylechui/nvim-surround",
        version = "*", -- Use for stability; omit to use `main` branch for the latest features
        event = "VeryLazy",
        config = function()
            require("nvim-surround").setup({
                -- Configuration here, or leave empty to use defaults
            })
        end
    },
    ]]
    -- TESTING

})
