{ pkgs, ... }:

{
  home.packages = with pkgs; [
    (writeShellScriptBin "eww-workspace" ''
      # pass input to hyprctl
      ${pkgs.hyprland}/bin/hyprctl dispatch "$@"

      # add yuck code to an array
      IFS=$'\n'
      widgets=('(box :class "widgets" :space-evenly true :halign "start"'
      '(button :class "workspace_inactive" :onclick "eww-workspace workspace 1" "󰠱")'
      '(button :class "workspace_inactive" :onclick "eww-workspace workspace 2" "󰈹")'
      '(button :class "workspace_inactive" :onclick "eww-workspace workspace 3" "󰅩")'
      '(button :class "workspace_inactive" :onclick "eww-workspace workspace 4" "󰦨")'
      '(button :class "workspace_inactive_star" :onclick "eww-workspace workspace 5" "")'
      '(button :class "workspace_inactive" :onclick "eww-workspace workspace 6" "󰭹")'
      '(button :class "workspace_inactive" :onclick "eww-workspace workspace 7" "󰠱"))')

      # find which workspace is currently focused...
      focused="$(${pkgs.hyprland}/bin/hyprctl activeworkspace -j | ${pkgs.jq}/bin/jq '.id')"

      # ...and update the respective element in the widgets array
      widgets[$focused]="''${widgets[$focused]/inactive/focused}"

      # get all workspaces that have open windows...
      active=($(${pkgs.hyprland}/bin/hyprctl -j clients | \
        ${pkgs.jq}/bin/jq '.[] | .workspace.id' | ${pkgs.coreutils}/bin/sort -u))

      # ...and update the respective element in the widgets array
      # (excludes focused workspace because of previous commands)
      for i in "''${active[@]}"; do
          widgets[$i]="''${widgets[$i]/inactive/active}"
      done

      # now we can update the focused variable inside eww
      # this loads the yuck code stored within the widgets array
      ${pkgs.eww}/bin/eww update focused="$(${pkgs.coreutils}/bin/echo ''${widgets[@]} | ${pkgs.coreutils}/bin/tr -d '\n')"
    '')

    (writeShellScriptBin "eww-layout" ''
      hyprctl dispatch "$1"
      fullscreen_status="$(hyprctl activewindow -j | ${pkgs.jq}/bin/jq '.fullscreen')"
      [[ "$fullscreen_status" == 1 ]] && fullscreen_mode="$(hyprctl activewindow -j | ${pkgs.jq}/bin/jq '.fullscreenMode')"
      if [[ "$fullscreen_mode" == 'null' ]]; then
          ${pkgs.eww}/bin/eww update layout=2
      else
          floating_status="$(hyprctl activewindow -j | ${pkgs.jq}/bin/jq '.floating')"
          if [[ "$floating_status" == 'true' ]]; then
              ${pkgs.eww}/bin/eww update layout=1
          else
              ${pkgs.eww}/bin/eww update layout=0
          fi
      fi
    '')

    (writeShellScriptBin "eww-battery" ''
      if [ "$1" == 'charge' ]; then
        upower -i /org/freedesktop/UPower/devices/battery_BAT0 | awk '/percentage/ {print $2}' | tr -d %
      elif [ "$1" == 'time' ]; then
        info="$(upower -i /org/freedesktop/UPower/devices/battery_BAT0 | awk '/time to/ {print $3 $4 " " $5}')"
        time="$(echo $info | cut -d':' -f2)"
        # if discharging
        if [[ "$info" =~ 'empty' ]]; then
            echo "$time remaining"
        # if charging
        elif [[ "$info" =~ 'full' ]]; then
            echo "$time remaining until full charge"
        else
            echo 'Calculating time remaining...'
        fi
      elif [ "$1" == 'status' ]; then
        upower -i /org/freedesktop/UPower/devices/battery_BAT0 | awk '/state/ {print $2}'
      elif [ "$1" == 'icon' ]; then
        status="$(upower -i /org/freedesktop/UPower/devices/battery_BAT0 | awk '/state/ {print $2}')"
        [ "$status" == 'discharging' ] && charge="$(upower -i /org/freedesktop/UPower/devices/battery_BAT0 | awk '/percentage/ {print $2}' | tr -d %)"
        if [ "$status" == 'charging' ]; then
          echo '󰂄'
          eww update selected_battery_icon=0
        elif [ "$charge" -eq 100 ]; then
          echo '󰁹'
        elif [ "$charge" -ge 90 ]; then
          echo '󰂂'
        elif [ "$charge" -ge 80 ]; then
          echo '󰂁'
        elif [ "$charge" -ge 70 ]; then
          echo '󰂀'
        elif [ "$charge" -ge 60 ]; then
          echo '󰁿'
        elif [ "$charge" -ge 50 ]; then
          echo '󰁾'
        elif [ "$charge" -ge 40 ]; then
          echo '󰁽'
        elif [ "$charge" -ge 30 ]; then
          echo '󰁼'
        elif [ "$charge" -ge 20 ]; then
          echo '󰁻'
          eww update selected_battery_icon=0
        elif [ "$charge" -ge 10 ]; then
          echo '󰁺'
          eww update selected_battery_icon=1
        elif [ "$charge" -lt 10 ]; then
          echo '󰂃'
          eww update selected_battery_icon=2
        fi
      fi
    '')
  ];
}
