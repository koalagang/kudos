{ pkgs, ... }:

{
  home = {
    # install timewarrior
    packages = with pkgs; [ timewarrior ];

    # set dark theme
    file.".config/timewarrior/timewarrior.cfg".text = ''
      import ${pkgs.timewarrior}/share/doc/timew/doc/themes dark.theme
    '';
  };
}
