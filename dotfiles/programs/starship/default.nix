{
  programs.starship = {
    enable = true;

    enableBashIntegration    = true;
    enableFishIntegration    = true;
    enableIonIntegration     = true;
    enableNushellIntegration = true;
    enableZshIntegration     = true;

    settings = {
      line_break.disabled = true;
      command_timeout = 1000;
      # TODO: nix-colors
    };
  };
}
