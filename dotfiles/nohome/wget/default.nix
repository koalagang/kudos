{ pkgs, config, ... }:

{
  home = {
    packages = [ pkgs.wget ];

    # Follow XDG base directory spec
    file."${config.xdg.configHome}/wget/wgetrc".text = ''
      hsts-file = "${config.xdg.dataHome}/wget-hsts"
    '';
    sessionVariables.WGETRC = "${config.xdg.configHome}/wget/wgetrc";
  };
}
