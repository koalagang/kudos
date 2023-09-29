{
  programs.translate-shell = {
    enable = true;

    # TODO: nix-colors
    #settings.theme = {}
  };

  home.shellAliases.dict = "trans -d";
}
