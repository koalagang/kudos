{ pkgs, ... }:

{
  programs.bat = {
    enable = true;

    # TODO: stylix
    config.theme = "Dracula";

    extraPackages = with pkgs.bat-extras; [ batman batgrep ];
  };
}
