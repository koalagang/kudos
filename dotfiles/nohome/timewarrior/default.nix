{ config, pkgs, ... }:

{
  home = {
    # install timewarrior
    packages = [ pkgs.timewarrior ];

    # set dark theme
    file."${config.xdg.configHome}/timewarrior/timewarrior.cfg".text = ''
      import ${pkgs.timewarrior}/share/doc/timew/doc/themes dark.theme
    '';
  };
}
