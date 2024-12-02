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
    skate

    # Misc
    testdisk
    nix-tree
    remind
    wyrd
    khal # -- to use for ical calendar; I will consider trying out ical2rem later
  ];

  imports = [
    ./dotfiles
    ./scripts
    inputs.nix-colors.homeManagerModules.default
    inputs.impermanence.nixosModules.home-manager.impermanence
  ];

  colorScheme = inputs.nix-colors.colorSchemes.catppuccin-mocha;

  # TODO: move options to related config files
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

        # misc
        ".config/syncthing" # needed to persist device identification
        ".local/share/Trash" # xdg trash directory
        ".local/share/direnv" # remember which directories to allow direnv
        ".local/share/zsh" # zsh history
        ".local/state/nvim/backup" # neovim file backups
        ".config/gnupg" # gpg keys are stored here
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
        ".local/share/mcfly"
        ".local/share/taskwarrior"
        ".local/share/timewarrior"
        ".local/share/zoxide"
        ".local/share/Anki2"
        ".config/Signal"
        ".config/chromium"
        ".config/obsidian"
        ".mullvad"
        ".mozilla"
        ".cache/ripgrep-all"
        ".local/share/sioyek"
        ".local/share/syncthing/databases"
        ".config/Ferdium"

        # misc
        ".config/libreoffice" # in addition to its config, libreoffice stores the most recently opened files here
        ".local/state/nvim/undo"
        ".local/state/nvim/swap"
        ".local/state/nvim/shada"
        # neovim plugins are installed to here (won't be necessary once I switch to managing neovim plugins with nix)
        ".local/share/nvim/lazy"
        ".cache/keepassxc" # cache to remember last opened keepass database
        ".cache/nvim" # some neovim plugins use caching to improve performance
        ".config/zsh" # zcompdump (completion cache) files get placed in here
        # charmbraclet (https://github.com/charmbracelet) apps store data here, incl. skate's databases
        ".local/share/charm"
        ".local/share/khal" # calendar database
      ];
      allowOther = true;
    };
  };
}
