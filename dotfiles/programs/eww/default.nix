{ config, pkgs, ... }:

{
  # will switch to using the home-manager module once my eww config is complete
  home.packages = [ pkgs.eww ];
  # programs.eww = {
  #   enable = true;
  #   enableBashIntegration = true;
  #   enableFishIntegration = true;
  #   enableZshIntegration = true;
  #   configDir = "./eww";
  # };

  home.file."${config.xdg.configHome}/eww" = {
    source = config.lib.file.mkOutOfStoreSymlink "/home/dante/Desktop/git/kudos/dotfiles/programs/eww/eww";
    recursive = true;
  };

  imports = [ ./scripts.nix ];
}
