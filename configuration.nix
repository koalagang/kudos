# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      /etc/nixos/hardware-configuration.nix
    ];

  # Bootloader
  boot.loader = {
    grub = {
      enable = true;
      device = "/dev/sda";
      # Enable encryption support
      enableCryptodisk = true;
      # Limit the number of generations accessible with grub to save space in /boot
      configurationLimit = 30;
    };
    # Set wait time to 1 (boot in faster)
    timeout = 1;
  };

  # Setup keyfile
  boot.initrd.secrets = {
    "/crypto_keyfile.bin" = null;
  };

  # I'm trying to find a way to use the label instead of the UUID
  # so that it is easily reproducible on any system.
  # It might require me to re-install but via the commandline
  # instead of using the calamares installer.
  # Will probably use disko.
  # I'll sort this out at some point but for now I'm gonna focus on other areas of nix.
  boot.initrd.luks.devices."luks-6cb12de3-3fc0-4cb0-9cf2-b16342b7aa3e".keyFile = "/crypto_keyfile.bin";
  #boot.initrd.luks.devices = {
  #  luksroot = {
  #    device = "/dev/disk/by-label/HOME";
  #    keyFile = "/crypto_keyfile.bin";
  #  };
  #};

  # Define your hostname.
  networking.hostName = "Myla";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enables wireless support via iwd
  networking.wireless.iwd.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/London";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_GB.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_GB.UTF-8";
    LC_IDENTIFICATION = "en_GB.UTF-8";
    LC_MEASUREMENT = "en_GB.UTF-8";
    LC_MONETARY = "en_GB.UTF-8";
    LC_NAME = "en_GB.UTF-8";
    LC_NUMERIC = "en_GB.UTF-8";
    LC_PAPER = "en_GB.UTF-8";
    LC_TELEPHONE = "en_GB.UTF-8";
    LC_TIME = "en_GB.UTF-8";
  };

  # Configure X11
  services.xserver = {
    enable = true;

    layout = "gb";
    xkbVariant = "";

    displayManager = {
      lightdm = {
        enable = true;
        # Respect the XDG base directory spec
        extraConfig = "user-authority-in-system-dir=true";
      };
      defaultSession = "none+dwm";
    };

    # Don't install xterm
    excludePackages = [ pkgs.xterm ];
  };

  # Configure console keymap
  console.keyMap = "uk";

  # Define a user account
  users.users.dante = {
    isNormalUser = true;
    description = "dante";
    extraGroups = [ "wheel" ];
    initialPassword = "zoteboat"; # Don't forget to change the password with 'passwd'
    packages = with pkgs; [];
    shell = pkgs.zsh;
  };
  programs.zsh.enable = true; # See home-manager for config

  # Swap out sudo for doas
  # If for whatever reason doas does not work,
  # resort to entering root via `su` as your backup plan
  security.sudo.enable = false;
  security.doas = {
    enable = true;
    extraRules = [{
      groups = [ "wheel" ];
      persist = true;
      # this option is crucial
      # `doas nixos-rebuild switch` will not work without it
      keepEnv = true;
    }];
  };

  # I generally avoid proprietary software in almost all cases
  # but refusing to update your CPU microcode exposes you to exploits
  # because then you do not get security updates for your CPU firmware
  nixpkgs.config.allowUnfree = false;     # reject most nonfree software...
  hardware = {
    enableRedistributableFirmware = true; # ...but make exceptions for redistributable firmware
    cpu.intel.updateMicrocode = true;     # and make sure to update the Intel microcode
    # cpu.amd.updateMicrocode = true;     # use this option instead if you have an AMD CPU
  };

  # I don't use nano, perl, rsync or strace (the defaults).
  # However, I do need to make sure I've always got an editor around (hence neovim)
  # and git must always be present too in case I want to revert my flake.lock.
  # There's also this issue https://discourse.nixos.org/t/getting-the-head-of-the-git-tree-failed/21837
  environment.defaultPackages = with pkgs; [ neovim git ];

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [

    # should I add these to a flake or shell.nix? (to use in latex projects)
    #texlive -- figure out later what package you need
    #biber

    # Base
    # These are some basic commandline tools that come installed with almost all GNU/Linux distributions
    # Most (or even all) of them are probably pulled as dependencies of other packages or my scripts
    # but I may as well declare them here too
    coreutils
    curl
    file
    findutils
    gawk
    gnugrep
    gnused
    gnutar
    killall
    poppler_utils
    procps
    wget

    # GUI
    signal-desktop
    keepassxc
    libreoffice-still jre_minimal
    mullvad-browser
    ungoogled-chromium

    # Powerful CLI tools
    imagemagick
    ffmpeg
    sox
    # DO NOT REMOVE GIT
    # see https://discourse.nixos.org/t/getting-the-head-of-the-git-tree-failed/21837 for why
    git # will probably switch to programs.git options

    # Simple but useful CLI tools
    xclip
    wl-clipboard
    colorpicker
    ddgr
    so
    ytfzf
    devour

    # Script dependencies
    # Will remove these once I've moved my scripts to nix via `writeShellScriptBin`
    xdotool
    recode
    maim
    playerctl
    pamixer
    bc

    # Misc CLI tools
    testdisk

    # Autostart tools
    # Will remove these once I've migrated to wayland
    xorg.xkbcomp
    xwallpaper
    dunst libnotify
    sxhkd
    xcompmgr

    # suckless
    # Will remove these once I've migrated to wayland
    dmenu
    dwm
    dwmblocks
    slock
    st
    sxiv
  ];

  programs.slock.enable = true;
  services.xserver.windowManager.dwm.enable = true;
  nixpkgs.overlays = [
    (final: prev: {
        dmenu = prev.dmenu.overrideAttrs (old: {
        src = builtins.fetchTarball "https://github.com/suckless-koala/dmenu/tarball/master";
        sha256 = "0mdqa9w1p6cmli6976v4wi0sw9r4p5prkj7lzfd1877wk11c9c73";
        buildInputs = with pkgs; [
            xorg.libX11
            xorg.libXft
            freetype
        ]; });
    })
    (final: prev: {
        dwm = prev.dwm.overrideAttrs (old: {
        src = builtins.fetchTarball "https://github.com/suckless-koala/dwm/tarball/master";
        buildInputs = with pkgs; [
            xorg.libX11
            xorg.libXft
            fontconfig
            freetype
        ]; });
    })
    (final: prev: {
        dwmblocks = prev.dwmblocks.overrideAttrs (old: {
        src = builtins.fetchTarball "https://github.com/suckless-koala/dwmblocks/tarball/laptop";
        sha256 = "0mdqa9w1p6cmli6976v4wi0sw9r4p5prkj7lzfd1877wk11c9c73";
        buildInputs = with pkgs; [
            xorg.libX11
        ]; });
    })
    (final: prev: {
        slock = prev.slock.overrideAttrs (old: {
        src = builtins.fetchTarball "https://github.com/suckless-koala/slock/tarball/master";
        sha256 = "0mdqa9w1p6cmli6976v4wi0sw9r4p5prkj7lzfd1877wk11c9c73";
        buildInputs = with pkgs; [
            xorg.libX11
            xorg.libXext
            xorg.libXrandr
            libxcrypt
        ]; });
    })
    (final: prev: {
        st = prev.st.overrideAttrs (old: {
        src = builtins.fetchTarball "https://github.com/suckless-koala/st/tarball/master";
        sha256 = "0mdqa9w1p6cmli6976v4wi0sw9r4p5prkj7lzfd1877wk11c9c73";
        buildInputs = with pkgs; [
            xorg.libX11
            xorg.libXft
            xorg.libXrender
            fontconfig
            freetype
            harfbuzz
        ]; });
    })
    (final: prev: {
        sxiv = prev.sxiv.overrideAttrs (old: {
        src = builtins.fetchTarball "https://github.com/suckless-koala/sxiv/tarball/master";
        sha256 = "0mdqa9w1p6cmli6976v4wi0sw9r4p5prkj7lzfd1877wk11c9c73";
        buildInputs = with pkgs; [
            xorg.libX11
            xorg.libXft
            fontconfig
            freetype
            imlib2
            giflib
            libexif
        ]; });
    })
  ];

  # WIP
  programs.hyprland.enable = true;
  security.pam.services.swaylock = {};

  # Dconf is necessary for gtk theming if you're not using a DE.
  # See https://github.com/nix-community/home-manager/issues/3113 for more
  programs.dconf.enable = true;

  fonts.packages = with pkgs; [
    fira-code
    freefont_ttf
    liberation_ttf
    noto-fonts-emoji
    source-han-serif
    source-han-sans
    (nerdfonts.override { fonts = [ "FiraCode" ]; })
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # location is necessary for redshift
  # even though I always keep the same screen temperature regardless of the time of day
  location = {
    provider = "manual";
    # London
    latitude = 51.50722;
    longitude = -0.1275;
  };
  services = {
    # blue light filter
    redshift = {
        enable = true;
        temperature = {
            day = 2500;
            night = 2500;
        };
    };

    # audio server
    pipewire = {
        enable = true;
        alsa.enable = true;
        alsa.support32Bit = true;
        pulse.enable = true;
        wireplumber.enable = true;
    };

    # hide cursor after three seconds of inactivity
    unclutter-xfixes = {
        enable = true;
        timeout = 3;
    };

    # optimise battery life and health
    auto-cpufreq.enable = true;

    # reduce overheating of Intel CPUs
    thermald.enable = true;

    # optimise SSD health and performance
    fstrim.enable = true;
  };

  nix = {
    # Install and...
    package = pkgs.nixFlakes;
    settings = {
      # enable flakes
      experimental-features = "nix-command flakes";

      # Respect the XDG base directory spec
      use-xdg-base-directories = true;
    };
  };

  # For some reason, git opens an annoying graphical askpass window
  # instead of asking for the username and password in the terminal.
  # This disables that.
  programs.ssh.enableAskPassword = false;
  # See https://github.com/NixOS/nixpkgs/issues/24311 for more

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?
}
