{ pkgs, ... }:

{
  programs.bat = {
    enable = true;

    # TODO: stylix
    config.theme = "Dracula";

    extraPackages = with pkgs.bat-extras; [ batman batgrep ];
  };

  programs.man.enable = true;
  home.shellAliases = {
    bg  = "batgrep --smart-case";
    cat = "bat --style=numbers";
    man = "batman";
  };
}
