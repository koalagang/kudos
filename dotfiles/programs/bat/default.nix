{ pkgs, ... }:

{
  imports = [ ./theme.nix ];
  programs.bat = {
    enable = true;
    config.theme = "custom";
    extraPackages = with pkgs.bat-extras; [ batman batgrep ];
  };

  programs.man.enable = true;
  home.shellAliases = {
    bg  = "batgrep --smart-case";
    cat = "bat --style=numbers";
    man = "batman";
  };
}
