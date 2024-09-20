# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, inputs, pkgs, lib, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./boot.nix
  ];

  networking = {
    # define hostname
    hostName = "Myla";

    # enable wifi support via iwd
    wireless.iwd = {
      enable = true;
      settings = {
        Settings.AutoConnect = true;
        # MAC address randomisation
        General = {
          AddressRandomization = "network";
          AddressRandomizationRange = "nic";
        };
      };
    };

    # use networkd instead of dhcpcd
    dhcpcd.enable = false;
    useNetworkd = true;
  };
  # enable networkd and resolved
  systemd.network.enable = true;
  services.resolved.enable = true;

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

  # greeter aka login manager aka display manager
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        # silence hyprland output to avoid polluting the tty with pointless text
        command = "${pkgs.greetd.greetd}/bin/agreety -c ${pkgs.hyprland}/bin/hyprland >/dev/null 2>&1";
        user = "greeter";
      };
      # enable auto-login
      initial_session = {
        command = "${pkgs.hyprland}/bin/hyprland >/dev/null 2>&1";
        user = "dante";
      };
    };
  };
  # silence greetd logs and errors
  # use `journalctl -u greetd` to take a look at logs
  systemd.services.greetd.serviceConfig = {
    StandardInput = "null";
    StandardOutput = "null";
    StandardError = "journal";
  };

  # Configure console keymap
  console.keyMap = "uk";

  users = {
    mutableUsers = false;
    defaultUserShell = pkgs.zsh;
    root.hashedPasswordFile = "/persist/hashed-password";
    # Define a user account
    dante = {
      isNormalUser = true;
      description = "dante";
      extraGroups = [
        "wheel" # admin
        "video" # for `light` command
      ];
      hashedPasswordFile = "/persist/hashed-password";
    };
  };

  # WORKAROUND:
  # If setting zsh to be the default interactive shell
  # but without the nixos module enabled, you get this warning:
  # programs.zsh.enable is not true. This will cause the zsh
  # shell to lack the basic nix directories in its PATH and might make
  # logging in as that user impossible.
  # However, enabling it will create /etc/zshrc, which has a number of default options.
  # Given that I use the home-manager module to configure zsh,
  # all the nixos-generated config does is slow down the startup time.
  # For example, I enable completion using the home-manager module,
  # so having it enabled using the NixOS module as well
  # just results in the completion commands being run twice.
  # The below options are an attempt to minimise this.
  programs = {
    zsh = {
      enable = true;

      # disable as much as possible
      setOptions = [];
      promptInit = "";
      enableLsColors = false;
      enableCompletion = false; # most significant
    };

    # marginally useful but adds to startup time,
    # plus it adds to the time before you can type another command after making a typo
    command-not-found.enable = false;
  };

  # Disable sudo, as run0 (systemd's privilige escalation tool) is more secure.
  # If, for whatever reason, run0 does not work,
  # resort to entering root via `su` as your backup plan.
  security = {
    sudo.enable = false;
    polkit.enable = true; # polkit is required for run0 to work
  };
  # run0 does not have access to all environmental variables by default
  # but PATH and LOCALE_ARCHIVE are needed for nixos-rebuild so we pass those into the command.
  # Simply use this `run` alias for rebuilds, e.g. `run nixos-rebuild switch`.
  environment.shellAliases."run" = "run0 --setenv=PATH --setenv=LOCALE_ARCHIVE";

  # don't allow unfree software...
  nixpkgs.config.allowUnfree = false;
  # ... with the exception of Obsidian
  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [ "obsidian" ];

  # I don't use nano, perl, rsync or strace (the defaults).
  # However, I do need to make sure I've always got an editor around (hence neovim)
  # and git must always be present too in case I want to revert my flake.lock.
  # There's also this issue https://discourse.nixos.org/t/getting-the-head-of-the-git-tree-failed/21837
  # so DO NOT REMOVE GIT
  environment.defaultPackages = with pkgs; [ neovim git ]; # Did you read the comment?

  # package from rose-pine-hyprcursor flake input
  # I'm not sure how to import this into homemanager so I'm installing it here
  environment.systemPackages = [ inputs.rose-pine-hyprcursor.packages.${pkgs.system}.default ];

  # force apps to run natively on wayland (rather than using xwayland)
  environment.variables = {
    NIXOS_OZONE_WL = 1; # electron
    QT_QPA_PLATFORM = "wayland"; # qt
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

    # Automatically optimise the store monthly to avoid wasting storage
    #optimise.automatic = true;
  };

  # will enable once the next version of nh is released (so I can use run0)
  # see https://github.com/viperML/nh/pull/92#issuecomment-2330891767
  #programs.nh = {
  #  enable = true;
  #  flake = "/home/dante/Desktop/git/kudos";
  #  #clean = {
  #  #  enable = true;
  #  #  extraArgs = "";
  #  #}
  #};

  # other stuff in the hyprland ecosystem are declared in their respective home-manager modules
  # these two lines are the only ones that must be included in configuration.nix
  programs.hyprland.enable = true;
  # set up pam integration with hyprlock
  # without this, you will not be able to unlock your system after running hyprlock
  security.pam.services.hyprlock = {};

  # Dconf is necessary for gtk theming if you're not using a DE.
  # See https://github.com/nix-community/home-manager/issues/3113 for more
  programs.dconf.enable = true;

  # provides command and enables udev permissions to allow members of the `video` group to modify backlight brightness
  programs.light.enable = true;

  # all these fonts are free (no unfree fonts here)
  fonts = {
    packages = with pkgs; [
      victor-mono # very nice for programming
      liberation_ttf # provides free versions of proprietary fonts, like Times New Roman and Arial
      source-han-sans source-han-serif # Adobe's simplified and traditional Chinese, Japanese and Korean (CJK) fonts
      freefont_ttf # GNU's font which covers tons of writing systems not covered by most other fonts
      noto-fonts-emoji # Google's emoji font
      (nerdfonts.override { fonts = [ "FiraCode" ]; }) # for icons
    ];
    fontconfig = {
      enable = true;
      defaultFonts = {
        serif = [ "Liberation Serif" "Source Han Serif" ];
        sansSerif = [ "Liberation Sans" "Source Han Sans" ];
        monospace = [ "Victor Mono" ];
        emoji = [ "Noto Color Emoji" ];
      };
    };
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:
  services = {
    # audio server
    pipewire = {
        enable = true;
        alsa = {
          enable = true;
          support32Bit = true;
        };
        pulse.enable = true;
        wireplumber.enable = true;
    };

    # optimise SSD health and performance
    fstrim.enable = true;

    upower = {
      enable = true;
      percentageLow = 19;
      percentageCritical = 9;
      criticalPowerAction = "HybridSleep"; # TODO: switch to hibernate once youve setup swap
    };
  };

  # WORKAROUND:
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
