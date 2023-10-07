{ pkgs, config, ... }:

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
  #programs.waybar = {
  #  enable = true;
  #  systemd.enable = true;
  #};
  home.file."${config.xdg.configHome}/waybar" = {
    source = config.lib.file.mkOutOfStoreSymlink "/home/dante/Desktop/git/gross/dotfiles/misc/hyprland/waybar";
    recursive = true;
  };
  home.packages = with pkgs; [ bemenu waybar ];

  # for now I'm making an out of store symlink
  # because this allows me to hot reload when inside hyprland
  # however, once I finish my setup I will port this to nix using the homemanager module
  home.file."${config.xdg.configHome}/hypr/hyprland.conf" = {
    source = config.lib.file.mkOutOfStoreSymlink "/home/dante/Desktop/git/gross/dotfiles/misc/hyprland/hyprland.conf";
  };
}
