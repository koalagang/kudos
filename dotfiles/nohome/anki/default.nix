{ pkgs, ... }:

{
  home = {
    packages = [ pkgs.anki-bin ];
    # disable qt5 shim and use qt6 instead
    sessionVariables.DISABLE_QT5_COMPAT = 1;
  };
}
