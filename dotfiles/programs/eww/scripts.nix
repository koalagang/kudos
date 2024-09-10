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

    (writeShellScriptBin "eww-battery" ''
        [ "$status" != 'charging' ] && \
          charge="$(upower -i /org/freedesktop/UPower/devices/battery_BAT0 | awk '/percentage/ {print $2}' | tr -d %)"
        if [ "$charge" -ge 20 ]; then
          eww update battery_icon_type=0
        elif [ "$charge" -ge 10 ]; then
          eww update battery_icon_type=1
        elif [ "$charge" -lt 10 ]; then
          eww update battery_icon_type=2
        fi

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
        [ "$status" != 'charging' ] && charge="$(upower -i /org/freedesktop/UPower/devices/battery_BAT0 | awk '/percentage/ {print $2}' | tr -d %)"
        if [ "$status" == 'charging' ]; then
          echo '󰂄'
          eww update battery_icon_type=0
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
        elif [ "$charge" -ge 10 ]; then
          echo '󰁺'
        elif [ "$charge" -lt 10 ]; then
          echo '󰂃'
        fi
      fi
    '')

    #(writeShellScriptBin "eww-settings" ''
    #  mkdir -p "$HOME/.cache/eww/settings"

    #  # run the command in the format `eww-settings <0|1> <widget>`
    #  # for example:
    #  # $ eww-settings 1 dnd
    #  echo 'crossfade' > "$HOME/.cache/eww/settings/transition"
    #  echo $1 > "$HOME/.cache/eww/settings/$2"
    #  echo 'none' > "$HOME/.cache/eww/settings/transition"

    #  # make sure to use deflisten for the respective files, e.g.
    #  # (deflisten dnd_transition "tail -f $HOME/.cache/eww/settings/transition")
    #  # (deflisten dnd_toggle "tail -f $HOME/.cache/eww/settings/dnd")
    #  # and then use the respective variables for :transition and :selected in the stack
    #'')
  ];
}
