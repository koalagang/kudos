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
    ferdium

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
    remind
    wyrd
  ];

  imports = [
    ./dotfiles
    ./scripts
    inputs.nix-colors.homeManagerModules.default
    inputs.impermanence.nixosModules.home-manager.impermanence
  ];

  colorScheme = inputs.nix-colors.colorSchemes.catppuccin-mocha;

  # TODO: consider removing nocow and moving everything in /persist/nocow to /persist???
  # I'm not sure there is significant enough overhead from the databases to warrant using nodatacow
  # + having a separate directory makes managing impermenance really annoying
  home.persistence = {
    "/persist/home/dante" = {
      directories = [
        # personal files
        "Desktop"
        "Documents"
        "Music"
        "Pictures"
        "Videos"

        # imperative configs
        ".config/keepassxc"
      ];
      # allow other users to access these files (needed for root operations)
      allowOther = true;
    };
    # use the nocow directory for databases and other stuff that is written to very often
    # this is to reduce SSD wear when using btrfs
    # make sure to run chattr +C on /persist/nocow on new installations before first boot
    "/persist/nocow/home/dante" = {
      directories = [
        # databases
        ".config/Signal"
        ".config/chromium"
        ".config/obsidian"
        ".mullvad"
        ".mozilla"
        ".config/Ferdium"

        # misc
        ".config/libreoffice" # in addition to its config, libreoffice stores the most recently opened files here
        ".cache/keepassxc" # cache to remember last opened keepass database
      ];
      allowOther = true;
    };
  };
}
