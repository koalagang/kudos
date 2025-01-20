{ pkgs, ... }:

{
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;

    enableBashIntegration    = true;
    enableNushellIntegration = true;
    enableZshIntegration     = true;
    enableFishIntegration    = pkgs.mkDefault true;
  };

  home = {
    # Ironically (in more ways than one),
    # I need to add an environmental variable to my shell to unclutter the screen from log output
    sessionVariables.DIRENV_LOG_FORMAT="";
    persistence."/persist/home/dante".directories = [ ".local/share/direnv" ];
  };
}
