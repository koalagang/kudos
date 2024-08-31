{ config, ... }:

{
  home.file."${config.xdg.configHome}/btop/themes/custom.theme".text = ''
    # Main background, empty for terminal default, need to be empty if you want transparent background
    theme[main_bg]="#${config.colorScheme.palette.base00}"

    # Main text colour
    theme[main_fg]="#${config.colorScheme.palette.base05}"

    # Title colour for boxes
    theme[title]="#${config.colorScheme.palette.base05}"

    # Highlight colour for keyboard shortcuts
    theme[hi_fg]="#${config.colorScheme.palette.base0D}"

    # Background colour of selected item in processes box
    theme[selected_bg]="#${config.colorScheme.palette.base03}"

    # Foreground colour of selected item in processes box
    theme[selected_fg]="#${config.colorScheme.palette.base0D}"

    # Colour of inactive/disabled text
    theme[inactive_fg]="#${config.colorScheme.palette.base02}"

    # Colour of text appearing on top of graphs, i.e uptime and current network graph scaling
    theme[graph_text]="#${config.colorScheme.palette.base06}"

    # Background colour of the percentage meters
    theme[meter_bg]="#${config.colorScheme.palette.base03}"

    # Misc colours for processes box including mini cpu graphs, details memory graph and details status text
    theme[proc_misc]="#${config.colorScheme.palette.base06}"

    # CPU, Memory, Network, Proc box outline colours
    theme[cpu_box]="#${config.colorScheme.palette.base0E}"
    theme[mem_box]="#${config.colorScheme.palette.base0B}"
    theme[net_box]="#${config.colorScheme.palette.base08}"
    theme[proc_box]="#${config.colorScheme.palette.base0D}"

    # Box divider line and small boxes line colour
    theme[div_line]="#${config.colorScheme.palette.base04}"

    # Temperature graph colour
    theme[temp_start]="#${config.colorScheme.palette.base0B}"
    theme[temp_mid]="#${config.colorScheme.palette.base0A}"
    theme[temp_end]="#${config.colorScheme.palette.base08}"

    # CPU graph colours
    theme[cpu_start]="#${config.colorScheme.palette.base0C}"
    theme[cpu_mid]="#${config.colorScheme.palette.base0D}"
    theme[cpu_end]="#${config.colorScheme.palette.base07}"

    # Mem/Disk free meter
    theme[free_start]="#${config.colorScheme.palette.base0E}"
    theme[free_mid]="#${config.colorScheme.palette.base07}"
    theme[free_end]="#${config.colorScheme.palette.base0D}"

    # Mem/Disk cached meter
    theme[cached_start]="#${config.colorScheme.palette.base0D}"
    theme[cached_mid]="#${config.colorScheme.palette.base0D}"
    theme[cached_end]="#${config.colorScheme.palette.base07}"

    # Mem/Disk available meter
    theme[available_start]="#${config.colorScheme.palette.base09}"
    theme[available_mid]="#${config.colorScheme.palette.base08}"
    theme[available_end]="#${config.colorScheme.palette.base08}"

    # Mem/Disk used meter
    theme[used_start]="#${config.colorScheme.palette.base0B}"
    theme[used_mid]="#${config.colorScheme.palette.base0C}"
    theme[used_end]="#${config.colorScheme.palette.base0D}"

    # Download graph colours
    theme[download_start]="#${config.colorScheme.palette.base09}"
    theme[download_mid]="#${config.colorScheme.palette.base08}"
    theme[download_end]="#${config.colorScheme.palette.base08}"

    # Upload graph colours
    theme[upload_start]="#${config.colorScheme.palette.base0B}"
    theme[upload_mid]="#${config.colorScheme.palette.base0C}"
    theme[upload_end]="#${config.colorScheme.palette.base0D}"

    # Process box colour gradient for threads, mem and cpu usage
    theme[process_start]="#${config.colorScheme.palette.base0C}"
    theme[process_mid]="#${config.colorScheme.palette.base07}"
    theme[process_end]="#${config.colorScheme.palette.base0E}"
  '';
}
