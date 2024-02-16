{ config, pkgs, ... }:

# I may consider switching to watson at some point
# but for now timewarrior works just fine + it's a part of the taskwarrior ecosystem
# they both store data in plain text so writing a script to conver between them should be easy

{
  home = {
    # install timewarrior
    packages = [ pkgs.timewarrior ];

    # TODO: nix-colors
    # set dark theme
    file."${config.xdg.configHome}/timewarrior/timewarrior.cfg".text = ''
      import ${pkgs.timewarrior}/share/doc/timew/doc/themes dark.theme
    '';
  };
}
