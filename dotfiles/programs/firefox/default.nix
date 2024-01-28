{
  programs.firefox.enable = true;

  home.sessionVariables.BROWSER = "firefox";

  imports = [
    ./profiles/browsing.nix
    ./profiles/signin.nix
    ./settings.nix
  ];
}
