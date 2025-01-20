{ config, pkgs, ... }:

{
  programs.ripgrep = {
    enable = true;
    # no custom hex codes unfortunately but these will make use of the terminal colours
    arguments = [
      "--colors=path:fg:red"
      "--colors=line:fg:green"
      "--colors=column:fg:white"
      "--colors=match:fg:magenta"
    ];
  };

  # ripgrep utilities
  home = {
    packages = with pkgs; [
      ripgrep-all
      repgrep
      vgrep
    ];
    persistence."/persist/nocow/home/dante".directories = [ ".cache/ripgrep-all" ];
  };
}
