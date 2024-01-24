{ config, ... }:

{
  # most environmental variables are located in their respective files
  # these are the "misc" ones (i.e. ones without config files)
  home.sessionVariables = {
    # will probably remove
    # this in favour of using direnv for dev-related environmental variables
    CARGO_HOME="${config.xdg.dataHome}/cargo";
  };
}

