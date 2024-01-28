{
  programs.firefox = {
    enable = true;
    #profiles = {
    #  profile0 = import ./profiles/browsing.nix;
    #  profile1 = import ./profiles/signin.nix;
    #};
  };

  imports = [
    ./profiles/browsing.nix
    ./profiles/signin.nix
    ./settings.nix
  ];

  home.sessionVariables.BROWSER = "firefox";
}
