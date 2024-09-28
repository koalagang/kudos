-- Bootstrap lazy.nvim
-- EXTERNAL dependency: git
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- Filetypes for treesitter and LSP to lazy-load
local languages = { "sh", "bib", "tex", "make", "rust", "toml", "lua", "nix", "yuck" }

-- Set plugin config path in a variable in case I decide to move them
local conf = "plugins.conf."

vim.keymap.set("n", "<leader>l", "<cmd>Lazy<cr>")
require("lazy").setup({
    -- [[ RULES ]]
    -- Lazy load (almost) everything
    -- If a configuration is longer than two lines, put it in its own file
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
        -- direnv/direnv.vim
    -- + related extensions (for nvim-cmp, telescope, neorg)
    -- MAYBE
        -- mrcjkb/rustaceanvim
        -- kylechui/nvim-surround
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

    -- [[ LSP ]]
    {
        "neovim/nvim-lspconfig",
        ft = languages,
        config = function()
            require(conf .. "lsp")
        end,
    },

    -- [[ Treesitter ]]
    {
        "nvim-treesitter/nvim-treesitter",
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
         dependencies = "nvim-treesitter/nvim-treesitter",
         config = function()
            require("treesj").setup()
            vim.keymap.set("n", "tsj", "<cmd>TSJToggle<cr>")
         end,
    },

    -- [[ Markdown ]]
    { -- Obsidian <3 Neovim
      -- Vimscript alternative: vimwiki/vimwiki
        "epwalsh/obsidian.nvim",
        version = "*", -- recommended, use latest release instead of latest commit
        ft = "markdown",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-treesitter/nvim-treesitter",
            -- I have not marked telescope as a dependency because I lazy-load it with bindings
            -- "nvim-telescope/telescope.nvim",
            -- TODO: install nvim-cmp
            -- "hrsh7th/nvim-cmp",
        },
        config = function()
            require(conf .. "obsidian")
        end,
    },
    { -- Configurable tools for working with markdown in Neovim
        "tadmccorkle/markdown.nvim",
        keys = { "gs", "]c", "]p", "]]", "[[" },
        cmd = { "MDInsertToc", "MDResetListNumbering" },
        opts = {},
    },
    { -- A Vim/Neovim plugin for automated bullet lists
      -- Lua alternative: gaoDean/autolist.nvim
        "bullets-vim/bullets.vim",
        ft = "markdown",
        config = function()
            vim.cmd[[let g:bullets_outline_levels = ['std-'] ]]
        end,
    },
    { -- An experimental markdown previewer for Neovim
      -- TODO: open issue about markview not displaying headings correctly when folding
        "OXY2DEV/markview.nvim",
        ft = "markdown",
        dependencies = {
            "nvim-treesitter/nvim-treesitter",
            "nvim-tree/nvim-web-devicons"
        },
        config = function()
            require(conf .. "markview")
        end,
    },
    { -- Makes creating markdown tables not pure suffering
      -- Lua alternative: tadmccorkle/markdown.nvim
        "dhruvasagar/vim-table-mode",
        cmd = "TableModeToggle",
        config = function()
            vim.g.table_mode_corner = "|"
        end,
    },
    { -- Bringing images to Neovim
      -- NOTE 1: will not render images if it's on the first line of the file
      -- NOTE 2: if you use hyprland window swallowing,
      -- you'll want to change your terminal's title when using image.nvim
        "3rd/image.nvim",
        cmd = "Image",
        dependencies = "nvim-treesitter/nvim-treesitter",
        -- EXTERNAL: magick (luarock), imagemagick, curl, ueberzugpp
        config = function()
            require(conf .. "image")
        end,
    },
    {
        "arnamak/stay-centered.nvim",
        ft = "markdown",
        opts = {},
        enabled = false,
    },
    -- TODO: work on making folding work how I want it to (ideally it should look just like neorg's folding);
    -- TODO: zk-nvim

    -- [[ Navigation ]]
    { -- "Find, Filter, Preview, Pick. All lua, all the time."
      -- Vimscript alternative: junegunn/fzf.vim
        "nvim-telescope/telescope.nvim",
        branch = "0.1.x",
        cmd = "Telescope",
        keys = {
            "<c-t>", -- find files
            "<c-g>", -- live grep
            -- obsidian.nvim bindings
            "<c-q>",
            "<A-b>",
            "<A-t>",
            "<c-o>",
            "<leader>t",
        },
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
        },
        -- EXTERNAL: zoxide
        keys = "<c-t>z",
        config = function()
            vim.keymap.set("n", "<c-t>z", require("telescope").extensions.zoxide.list)
        end,
    },
    -- TODO: consider switching to folke/flash.nvim?
    { -- "Neovim motions on speed!"
      -- Vimscript alternative: easymotion/vim-easymotion
        "phaazon/hop.nvim",
        branch = "v2",
        keys = { "f", "F", "<localleader>1", "<localleader>2", { "f", mode = "v" }, { "F", mode = "v" } },
        config = function()
            require(conf .. "hop")
        end,
    },
    { -- "Neovim file explorer: edit your filesystem like a buffer"
      -- Vimscript alternative: tpope/vim-vinegar
        "stevearc/oil.nvim",
        keys = { "-" },
        cmd = "Oil",
        after = "jvgrootveld/telescope-zoxide",
        dependencies = "nvim-tree/nvim-web-devicons", -- EXTERNAL: any nerdfont
        -- EXTERNAL: trash-cli (for trash feature)
        config = function()
            require(conf .. "oil")
        end
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
    -- Make using splits actually comfortable
    { -- Auto-focusing and auto-resizing splits/windows
        "nvim-focus/focus.nvim",
        version = "*",
        keys = {
            "<c-h>",
            "<c-j>",
            "<c-k>",
            "<c-l>",
            "<localleader>h",
            "<localleader>j",
            "<localleader>k",
            "<localleader>l",
            "<localleader>f",
        },
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

    -- [[ Git ]]
    { -- An interactive and powerful Git interface for Neovim, inspired by Magit
      -- Vimscript alternative: tpope/vim-fugitive
      -- TODO: learn how to use this
      "NeogitOrg/neogit",
      cmd = "Neogit",
      dependencies = {
        "nvim-lua/plenary.nvim",         -- required
        "sindrets/diffview.nvim",        -- optional - Diff integration
        "nvim-telescope/telescope.nvim", -- optional
      },
      config = function()
        require(conf .. "neogit")
      end,
    },
    -- TODO: gitsigns and octo

    { -- The undo history visualizer for Vim
      -- Lua alternative: jiaoshijie/undotree
        "mbbill/undotree",
        keys = { "<localleader>u" },
        config = function()
            vim.w.focus_disable = true -- disable focus.nvim for undotree
            vim.keymap.set("n", "<localleader>u", "<cmd>UndotreeToggle<cr><cmd>UndotreeFocus<cr>", { noremap = true, silent = true })
        end,
    },

    ---- [[ Misc ]] ----

    { -- Dracula colourscheme
       "Mofiqul/dracula.nvim",
       -- One of the few plugins I don't lazy-load
       -- High priority to make sure the colourscheme is loaded before everything else
       priority = 1000,
       config = function()
          require(conf .. "dracula")
       end,
       enabled = false,
    },
    {
        "catppuccin/nvim",
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
      -- Vimscript alternative: ap/vim-css-color
        "norcalli/nvim-colorizer.lua",
        cmd = "ColorizerToggle",
        config = function()
            require("colorizer").setup()
        end,
    },
    { -- Indentation line-guides
      -- Vimscript alternative: Yggdroot/indentLine
        "lukas-reineke/indent-blankline.nvim",
        main = "ibl",
        dependencies = { "nvim-treesitter/nvim-treesitter", "HiPhish/rainbow-delimiters.nvim" },
        ft = languages,
        config = function()
            require(conf .. "indent-blankline")
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

    { -- Align text
      -- by selecting it in visual block mode
      -- and hitting <leader>a followed by your character to align to
      -- Vimscript alternative: junegunn/vim-easy-align (TODO: swap to mini.align)
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

    { -- A telescope extension to view and search your undo tree
        "debugloop/telescope-undo.nvim",
        dependencies = "nvim-telescope/telescope.nvim",
        keys = "<leader>u",
        config = function()
            require("telescope").load_extension("undo")
            vim.keymap.set("n", "<leader>u", "<cmd>Telescope undo<cr>")
        end,
    },

    -- [[ FILETYPE PLUGINS ]]
    { -- ledger
        "ledger/vim-ledger",
        ft = { "ledger", "journal" },
        config = function()
            -- set tabs to two spaces
            vim.opt.tabstop = 2
            vim.opt.softtabstop = 2
            vim.opt.shiftwidth = 2
        end,
    },
    { -- yuck is a lisp-like syntax so parinfer is helpful
        "gpanders/nvim-parinfer",
        config = function()
            -- lisps use semicolons for commenting
            vim.opt.commentstring = "; %s"
        end,
        ft = "yuck",
    },

    -- W.I.P. migrating from neorg to obsidian (i.e. norg -> markdown)
    { -- "An Organized Future"
        "nvim-neorg/neorg",
        dependencies = {
            "nvim-treesitter/nvim-treesitter",

            -- EXTERNAL: lua-utils.nvim nvim-nio nui.nvim plenary.nvim pathlib.nvim (all are luarocks)
            {
                "nvim-neorg/neorg-telescope",
                dependencies = { "nvim-telescope/telescope.nvim" },
            },
        },
        cmd = "Neorg",
        ft = "norg",
        keys = "<c-t>n", -- for use with neorg-telescope
        version = "*",
        config = function()
            require(conf .. "neorg")
        end,
    },
    { -- A Neovim lua plugin to help easily manage multiple terminal windows
      -- Vimscript alternative: voldikss/vim-floaterm
        "akinsho/toggleterm.nvim",
        version = "*",
        keys = { "<m-cr>" },
        config = function()
            require(conf .. "toggleterm")
        end,
    },
})
