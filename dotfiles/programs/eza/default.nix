{
  programs.eza = {
    enable = true;
    enableBashIntegration = true;
    enableFishIntegration = true;
    enableIonIntegration = true;
    enableNushellIntegration = true;
    enableZshIntegration = true;
    icons = "auto";
  };

  home.shellAliases = {
    ls = "eza --all --long --no-permissions --no-user --no-time --group-directories-first --sort=size --binary";
    ll = "eza --long";
    tree = "eza --tree";
  };

  # Uses LS_COLORS variable generated by vivid (see vivid config)
}
