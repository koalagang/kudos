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
        emoji="$(${pkgs.coreutils}/bin/cut -d ';' -f1 ~/.local/share/emojis |
          ${config.home.sessionVariables.DMENU_CMD} -i -l 30 | ${pkgs.gnused}/bin/sed 's/ .*//')"

        # Exit if none chosen
        [ -z "$emoji" ] && exit

        ${pkgs.coreutils}/bin/echo "$emoji" |
          ${config.home.sessionVariables.COPY_CMD} && ${pkgs.libnotify}/bin/notify-send "$emoji copied to clipboard."
      '')
    ];
  };
}
