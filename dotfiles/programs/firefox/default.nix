{
  programs.firefox = {
    enable = true;
    profiles = {
      profile0 = import ./profiles/browsing.nix;
      profile1 = import ./profiles/signin.nix;
    };
  };

  home.sessionVariables.BROWSER = "firefox";
}
