{ config, pkgs, ... }:

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
  home = {
    # nvim-tree/nvim-web-devicons and nvim-neorg/neorg
    packages = with pkgs; [
      (nerdfonts.override { fonts = [ "FiraCode" ]; })
      # I've installed this with neovim.extraPackages
      # but installing it this way also seems to be necessary for tg to work (see lower down)
      ripgrep

      # open directory with oil.nvim
      # Examples:
      # vo . # open the current directory
      # vo ~/Documents # open documents
      (writeShellScriptBin "vo" ''
        ${pkgs.neovim}/bin/nvim -c "Oil $1"
      '')
    ];

    # Source lua config
    file."${config.xdg.configHome}/nvim" = {
      # Link the file outside of the nix store.
      # This allows me to edit my lua config without rebuilding nix
      # (unless I need to add avother package as seen above).
      # Specifying absolute path is necessary because flakes live in the nix store
      # so using an absolute path will allow us to create a symlink outside of the store.
      # I will probably change this once my neovim config has fewer moving parts.
      # See https://github.com/nix-community/home-manager/issues/257 for more.
      source = config.lib.file.mkOutOfStoreSymlink "/home/dante/Desktop/git/gross/dotfiles/programs/neovim/nvim";
      recursive = true;
    };

    shellAliases = {
      # go straight from the commandline into a live grep using telescope.nvim
      # this allows you to fuzzy find for a particular line and then open the text file on that line
      # recommended: have ripgrep installed
      tg = "${pkgs.neovim}/bin/nvim -c 'Telescope live_grep'";
    };
  };
  # create zsh bindings for some of the aliases/scripts
  programs.zsh.initExtra = ''
    # ctrl+g -> perform telescope live grep
    bindkey -s '^g' 'tg^M'

    # ctrl+o -> open the current directory with oil.nvim
    bindkey -s '^o' 'vo .^M'
  '';
}
