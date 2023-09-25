{ config, pkgs, ... }:

{
  programs.neovim = {
    enable = true;

    defaultEditor = true;

    viAlias = true;
    #vimAlias = true;
    vimdiffAlias = true;

    # Dependencies
    extraPackages = with pkgs; [
      # Neovim system clipboard support
      xclip # X11
      #wl-clipboard # Wayland

      # PLUGIN DEPENDENCIES
      # lazy.nvim
      git

      # nvim-treesitter/nvim-treesitter
      curl
      gnutar
      gcc # and for telescope-fzf-native.nvim

      # nvim-telescope
      ripgrep # telescope.nvim
      fd # telescope.nvim
      gnumake # telescope-fzf-native.nvim

      # pwntester/octo.nvim
      github-cli

      # TODO:
      # LSP?
      # formatters?
      # linters?

      # make sure to checkhealth on all your plugins

      # 3rd/image.nvim
      imagemagick
      ueberzugpp
    ];
    extraLuaPackages = luaPkgs: with luaPkgs; [ magick ]; # this is also for 3rd/image.nvim
  };
  # nvim-tree/nvim-web-devicons and nvim-neorg/neorg
  home.packages = with pkgs; [ (nerdfonts.override { fonts = [ "FiraCode" ]; }) ];

  # Source lua config
  home.file.".config/nvim" = {
    # Link the file outside of the nix store.
    # This allows me to edit my lua config without rebuilding nix
    # (unless I need to add another package as seen above).
    # Specifying absolute path is necessary because flakes live in the nix store
    # so using an absolute path will allow us to create a symlink outside of the store.
    # I will probably change this once my neovim config has fewer moving parts.
    # See https://github.com/nix-community/home-manager/issues/257 for more.
    source = config.lib.file.mkOutOfStoreSymlink "/home/dante/Desktop/git/gross/modules/programs/neovim/nvim";
    recursive = true;
  };
}
