{ config, pkgs, ... }:

# Once I've got a comfy neovim setup that I think is unlikely to change,
# I'll probably switch to nixvim or use homemanager for configuring neovim
# but using lazy.nvim as I described here
# https://github.com/nix-community/nixvim/issues/421#issuecomment-1834169572
# I might also use nix for installing treesitter parsers rather than compiling them.

{
  programs.neovim = {
    enable = true;

    defaultEditor = true;

    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;

    # Dependencies
    extraPackages = with pkgs; [
      # Neovim system clipboard support
      wl-clipboard # Wayland
      xclip # X11
      #xsel # X11

      # PLUGIN DEPENDENCIES
      # lazy.nvim
      git

      # nvim-treesitter/nvim-treesitter
      curl # and for 3rd/image.nvim
      gnutar
      gcc # and for telescope-fzf-native.nvim

      # nvim-telescope
      ripgrep # telescope.nvim
      fd # telescope.nvim
      gnumake # telescope-fzf-native.nvim

      # pwntester/octo.nvim
      github-cli

      # stevearc/oil.nvim
      trash-cli

      # 3rd/image.nvim
      imagemagick
      ueberzugpp

      # jvgrootveld/telescope-zoxide
      zoxide

      # TODO:
      # LSP?
      # formatters?
      # linters?

      # TODO: checkhealth on all plugins
    ];

    # 3rd/image.nvim
    extraLuaPackages = luaPkgs: with luaPkgs; [ magick ];
  };

  home = {
    # nvim-tree/nvim-web-devicons and nvim-neorg/neorg
    packages = [ (pkgs.nerdfonts.override { fonts = [ "FiraCode" ]; }) ];

    # Source lua config
    file."${config.xdg.configHome}/nvim" = {
      # Link the file outside of the nix store.
      # This allows me to edit my lua config without rebuilding nix
      # (unless I need to add another package as seen above).
      # Specifying absolute path is necessary because flakes live in the nix store
      # but using an absolute path will allow us to create a symlink outside of the store.
      # I will probably change this once my neovim config has fewer moving parts.
      # See https://github.com/nix-community/home-manager/issues/257 for more.
      source = config.lib.file.mkOutOfStoreSymlink "/home/dante/Desktop/git/gross/dotfiles/programs/neovim/nvim";
      recursive = true;
    };
  };
}
