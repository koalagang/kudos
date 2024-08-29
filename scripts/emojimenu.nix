{ pkgs, config, ... }:

{

  home = {
    packages = [
      # You need at least one emoji font
      # You also need a DMENU_CMD with unicode support
      pkgs.noto-fonts-emoji

      (pkgs.writeShellScriptBin "emojimenu" ''
        # Get user selection via dmenu from emoji file
        # TODO: move emoji file to gross repo via glfs
        emoji="$(${pkgs.coreutils}/bin/cut -d ';' -f1 "${config.xdg.dataHome}/emojis" |
          ${config.home.sessionVariables.DMENU_CMD} ${config.home.sessionVariables.DMENU_EXTRA_FLAGS} -i -l 30 -p ''' |
          ${pkgs.gnused}/bin/sed 's/ .*//')"

        # Exit if none chosen
        [ -z "$emoji" ] && exit

        ${pkgs.coreutils}/bin/echo "$emoji" |
          ${config.home.sessionVariables.COPY_CMD} && ${pkgs.libnotify}/bin/notify-send "$emoji copied to clipboard."
      '')
    ];
  };
}
