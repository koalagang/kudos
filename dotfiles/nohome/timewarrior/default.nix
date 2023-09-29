{ config, pkgs, ... }:

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
