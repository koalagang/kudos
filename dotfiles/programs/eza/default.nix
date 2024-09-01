{ pkgs, config, ... }:

{
  programs.eza = {
    enable = true;
    icons = true;
  };

  home = {
    shellAliases = {
      ls = "eza --all --long --no-permissions --no-user --no-time --group-directories-first --sort=size --binary";
      ll = "eza --long";
      tree = "eza --tree";
    };
    sessionVariables.LS_COLORS="$(${pkgs.vivid}/bin/vivid generate \"$(echo ${config.colorScheme} | cut -d'.' -f4)\"";
  };
}
