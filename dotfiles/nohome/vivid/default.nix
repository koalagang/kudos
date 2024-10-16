{ pkgs, config, ... }:

{
  home = {
    sessionVariables.LS_COLORS = "$(${pkgs.vivid}/bin/vivid generate theme)";
    file."${config.xdg.configHome}/vivid/themes/theme.yml".text = ''
      # vivid has to have this 'colors' section even though we don't use it
      colors:
        black: '000000'

      core:
        normal_text: {}
        regular_file: {}
        reset_to_normal: {}

        directory:
          foreground: '${config.colorScheme.palette.base0E}'

        symlink:
          foreground: '${config.colorScheme.palette.base0D}'

        multi_hard_link: {}

        fifo:
          foreground: '${config.colorScheme.palette.base01}'
          background: '${config.colorScheme.palette.base0D}'

        socket:
          foreground: '${config.colorScheme.palette.base01}'
          background: '${config.colorScheme.palette.base0D}'

        door:
          foreground: '${config.colorScheme.palette.base01}'
          background: '${config.colorScheme.palette.base0D}'

        block_device:
          foreground: '${config.colorScheme.palette.base0C}'
          background: '${config.colorScheme.palette.base02}'

        character_device:
          foreground: '${config.colorScheme.palette.base0D}'
          background: '${config.colorScheme.palette.base02}'

        broken_symlink:
          foreground: '${config.colorScheme.palette.base01}'
          background: '${config.colorScheme.palette.base08}'

        missing_symlink_target:
          foreground: '${config.colorScheme.palette.base01}'
          background: '${config.colorScheme.palette.base08}'

        setuid: {}

        setgid: {}

        file_with_capability: {}

        sticky_other_writable: {}

        other_writable: {}

        sticky: {}

        executable_file:
          foreground: '${config.colorScheme.palette.base08}'
          font-style: bold

      text:
        special:
          foreground: '${config.colorScheme.palette.base00}'
          background: '${config.colorScheme.palette.base0A}'

        todo:
          font-style: bold

        licenses:
          foreground: '${config.colorScheme.palette.base06}'

        configuration:
          foreground: '${config.colorScheme.palette.base0A}'

          nix:
            foreground: '${config.colorScheme.palette.base0D}'

        other:
          foreground: '${config.colorScheme.palette.base0A}'

      markup:
        foreground: '${config.colorScheme.palette.base0A}'

      programming:
        source:
          foreground: '${config.colorScheme.palette.base0B}'

        tooling:
          foreground: '${config.colorScheme.palette.base0C}'

          continuous-integration:
            foreground: '${config.colorScheme.palette.base0B}'

      media:
        foreground: '${config.colorScheme.palette.base0F}'

      office:
        foreground: '${config.colorScheme.palette.base08}'

      archives:
        foreground: '${config.colorScheme.palette.base0C}'
        font-style: underline

      executable:
        foreground: '${config.colorScheme.palette.base08}'
        font-style: bold

      unimportant:
        foreground: '${config.colorScheme.palette.base04}'
    '';
  };
}
