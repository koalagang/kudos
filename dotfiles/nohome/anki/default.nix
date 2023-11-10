{ pkgs, ... }:

{
  home = {
    packages = with pkgs; [
      anki-bin
      (texlive.combine { inherit (texlive) scheme-medium dvipng chemformula; })
      ];
    # disable qt5 shim and use qt6 instead
    sessionVariables.DISABLE_QT5_COMPAT = 1;
  };
}
