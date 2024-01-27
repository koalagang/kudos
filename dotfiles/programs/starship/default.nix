{
  programs.starship = {
    enable = true;

    # Enable this for any shell installed and configured by home-manager
    enableBashIntegration    = true;
    enableFishIntegration    = true;
    enableIonIntegration     = true;
    enableNushellIntegration = true;
    enableZshIntegration     = true;

    settings = {
      line_break.disabled = true;
      command_timeout = 1000;
    };
  };
}
