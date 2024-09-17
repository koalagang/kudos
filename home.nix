{ config, pkgs, inputs, ... }:

{

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # Home Manager needs a bit of information about you and the paths it should manage.
  home.username = "dante";
  home.homeDirectory = "/home/${config.home.username}";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "23.05"; # Did you read the comment?

  # The home.packages option allows you to install Nix packages into your environment.
  home.packages = with pkgs; [
    # Base
    # These are some basic commandline tools that come installed with almost all GNU/Linux distributions
    # but I may as well declare them here just to be sure.
    coreutils
    findutils
    diffutils
    util-linux
    curl
    wget
    file
    gawk
    gnugrep
    gnused
    gnutar
    killall
    poppler_utils

    # GUI
    signal-desktop
    keepassxc
    libreoffice-still jre_minimal
    mullvad-browser
    ungoogled-chromium
    obsidian
    imv

    # Powerful CLI tools
    imagemagick
    ffmpeg

    # Simple but useful CLI tools
    wl-clipboard
    so
    ytfzf
    vimv-rs

    # Misc
    testdisk
    nix-tree
  ];

  colorScheme = inputs.nix-colors.colorSchemes.catppuccin-mocha;

  imports = [
    ./dotfiles
    ./scripts
    inputs.nix-colors.homeManagerModules.default
  ];
}
