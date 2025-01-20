{
  programs.mcfly = {
    enable = true;

    enableBashIntegration = true;
    enableFishIntegration = true;
    enableZshIntegration  = true;

    fzf.enable = true;
    fuzzySearchFactor = 3;
    keyScheme = "vim";
  };

  home.persistence."/persist/nocow/home/dante".directories = [ ".local/share/mcfly" ];
}
