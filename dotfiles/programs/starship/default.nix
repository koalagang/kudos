{ config, ... }:

{
  programs.starship = {
    enable = true;

    enableBashIntegration    = true;
    enableFishIntegration    = true;
    enableIonIntegration     = true;
    enableNushellIntegration = true;
    enableZshIntegration     = true;

    settings = {
      line_break.disabled = true;
      command_timeout = 1000;
      git_branch.style = "bold #${config.colorScheme.palette.base0B}";
      git_status.style = "#${config.colorScheme.palette.base08}";
      directory.style = "#${config.colorScheme.palette.base0E}";
      cmd_duration.style = "bold #${config.colorScheme.palette.base0A}";
      character = {
        success_symbol = "[❯](bold #${config.colorScheme.palette.base0D})";
        vimcmd_symbol = "[❮](bold #${config.colorScheme.palette.base0D})";
        error_symbol = "[❯](bold #${config.colorScheme.palette.base09})";
      };
      # TODO: more colours
    };
  };
}
