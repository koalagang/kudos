{ pkgs, config, ... }:

# I am currently using a lot of out of store symlinks during the initial configuration process.
# This is to make it easy to change the configurations without the need for rebuilding.
# I am also storing most of my wayland-related configs here temporarily.
# Once I've got wayland fully set up and ready to daily drive,
# I'll port all my configs to homemanager modules and store them in their own separate directories.

{
  # make sure hyprland is installed via configuration.nix

  #wayland.windowManager.hyprland = {
  #  enable = true;
  #  systemdIntegration = true;
  #};

  # temporary
  # I'll create separate configs later
  programs.foot = {
    enable = true;
    server.enable = true;
  };
  home.file."${config.xdg.configHome}/foot/foot.ini" = {
    source = config.lib.file.mkOutOfStoreSymlink "/home/dante/Desktop/git/gross/dotfiles/misc/hyprland/foot.ini";
  };

  #programs.waybar = {
  #  enable = true;
  #  systemdIntegration.enable = true;
  #};
  home.file."${config.xdg.configHome}/waybar" = {
    source = config.lib.file.mkOutOfStoreSymlink "/home/dante/Desktop/git/gross/dotfiles/misc/hyprland/waybar";
    recursive = true;
  };

  home.file."${config.xdg.configHome}/fuzzel/fuzzel.ini" = {
    source = config.lib.file.mkOutOfStoreSymlink "/home/dante/Desktop/git/gross/dotfiles/misc/hyprland/fuzzel.ini";
  };
  programs.fuzzel.enable = true;

  # make sure to add `security.pam.services.swaylock = {};` to configuration.nix
  programs.swaylock.enable = true;

  # doesn't seem to work atm
  # maybe it'll start working once I've ported my hyprland config to nix
  services.swayidle = {
    enable = true;
    timeouts = [{
      timeout = 60;
      command = "${pkgs.swaylock}/bin/swaylock";
    }];
  };

  home.file."${config.xdg.configHome}/mako/config" = {
    source = config.lib.file.mkOutOfStoreSymlink "/home/dante/Desktop/git/gross/dotfiles/misc/hyprland/mako/config";
  };

  home.packages = with pkgs; [ mako waybar wlsunset ];
  # I also have wlsunset configured with homemanager (see services/wlsunset)
  # but it doesn't seem to work
  # maybe because I'm not currently use hyprland's homemanager module?

  # hyprland has support for hot-reloading
  home.file."${config.xdg.configHome}/hypr/hyprland.conf" = {
    source = config.lib.file.mkOutOfStoreSymlink "/home/dante/Desktop/git/gross/dotfiles/misc/hyprland/hyprland.conf";
  };

  # modified keyboard layout
  home.file."${config.xdg.configHome}/xkb/symbols/uk-no".source = ./uk-no;
}
