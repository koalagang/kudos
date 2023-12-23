{ pkgs, ... }:

{
  programs.ripgrep = {
    enable = true;

    # TODO: nix-colors
    #arguments = [
    #  --colors=
    #];
  };

  # ripgrep utilities
  home.packages = with pkgs; [
    #ripgrep-all # must be compiled (my puny ThinkPad gets hot and loud when doing this)
    repgrep
    vgrep
  ];
}
