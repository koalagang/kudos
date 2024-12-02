{ config, pkgs, ... }:

# I may consider switching to nixvim at some point in the future
# but I'll at least wait for it to have lazy-loading support.
# See relevant issues:
# https://github.com/nix-community/nixvim/issues/421
# https://github.com/nix-community/nixvim/issues/797

{
  programs.neovim = {
    enable = true;

    defaultEditor = true;

    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;

    # Dependencies
    extraPackages = with pkgs; [
      # System clipboard support (i.e. the plus+ register)
      wl-clipboard # Wayland
      #xclip # X11
      #xsel # X11

      # PLUGIN DEPENDENCIES
      # lazy.nvim
      git

      # nvim-treesitter/nvim-treesitter
      tree-sitter
      nodejs
      curl # and for 3rd/image.nvim
      gnutar
      gcc # and for telescope-fzf-native.nvim

      # nvim-telescope
      ripgrep # telescope.nvim
      gnumake # telescope-fzf-native.nvim

      # pwntester/octo.nvim
      #github-cli

      # 3rd/image.nvim
      imagemagick
      ueberzugpp

      # jvgrootveld/telescope-zoxide
      zoxide

      # LSP
      # I'll probably move these to per-project flakes
      texlab
      lua-language-server
      nixd
      taplo
      rust-analyzer cargo
      # formatters?
      # linters?

      # TODO: checkhealth on all plugins
   ];

    extraLuaPackages = luaPkgs: with luaPkgs; [
      # 3rd/image.nvim
      magick

      # nvim-neorg/neorg
      lua-utils-nvim
      nvim-nio
      nui-nvim
      plenary-nvim
      pathlib-nvim
    ];
  };

  # Source lua config
  home.file."${config.xdg.configHome}/nvim" = {
    /* Link the file outside of the nix store.
    This allows me to edit my lua config without rebuilding nix
    (unless I need to add another package as seen above).
    Specifying absolute path is necessary because flakes live in the nix store
    but using an absolute path will allow us to create a symlink outside of the store.
    I will probably change this once my neovim config has fewer moving parts.
    See https://github.com/nix-community/home-manager/issues/257 for more. */
    source = config.lib.file.mkOutOfStoreSymlink "/home/dante/Desktop/git/kudos/dotfiles/programs/neovim/nvim";
    recursive = true;
  };
}
