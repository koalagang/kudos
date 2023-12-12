{ pkgs, ... }:

{
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;

    # Enable this for any shell installed and configured by home-manager
    enableBashIntegration    = true;
    enableNushellIntegration = true;
    enableZshIntegration     = true;
    enableFishIntegration    = pkgs.mkDefault true;
  };

  # Ironically (in more ways than one),
  # I need to add an environmental variable to my shell to unclutter the screen from log output
  home.sessionVariables.DIRENV_LOG_FORMAT="";
}
