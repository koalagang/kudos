{ config, pkgs, ... }:

{
  programs.ripgrep = {
    enable = true;
    arguments = [
      "--color=always"
      "--colors='path:fg:0x${config.colorScheme.palette.base08}'"
      "--colors='line:fg:0x${config.colorScheme.palette.base0B}'"
      "--colors='column:fg:0x${config.colorScheme.palette.base05}'"
      "--colors='match:fg:0x${config.colorScheme.palette.base0E}'"
    ];
  };

  # ripgrep utilities
  home.packages = with pkgs; [
    #ripgrep-all # must be compiled (my puny ThinkPad gets hot and loud when doing this)
    repgrep
    vgrep
  ];
}
