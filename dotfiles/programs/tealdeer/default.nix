{
  programs.tealdeer = {
    enable = true;

    settings = {
      display.compact = true;
      update.auto_update = false;
      # TODO: nix-colors
      #style = {};
    };

    # causes home-manager service to fail on boot when true
    updateOnActivation = false;
  };
}
