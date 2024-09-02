{ pkgs, ... }:

{
  programs.ripgrep = {
    enable = true;
    # no custom hex codes unfortunately but these will make use of the terminal colours
    arguments = [
      "--color=always"
      "--colors 'path:fg:red'"
      "--colors 'line:fg:green'"
      "--colors 'column:fg:white'"
      "--colors 'match:fg:magenta'"
    ];
  };

  # ripgrep utilities
  home.packages = with pkgs; [
    #ripgrep-all # must be compiled (my puny ThinkPad gets hot and loud when doing this)
    repgrep
    vgrep
  ];
}
