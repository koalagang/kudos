{ pkgs, ... }:

{
  home.packages = with pkgs; [
    libnotify # used by pomodoro scripts (which I will port to writeShellScriptBin soon)

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

    # BUG: circle stays yellow even when charging.
    # hovering over it will make it green but then after a minute it will go back to being yellow
    (writeShellScriptBin "eww-battery" ''
        # NOTE: whether to use BAT1 or BAT0 may depend on the laptop
        # perhaps I should modify the script so that it works regardless of the battery's name
        [ "$status" != 'charging' ] && \
          charge="$(${pkgs.upower}/bin/upower -i /org/freedesktop/UPower/devices/battery_BAT1 | ${pkgs.gawk}/bin/awk '/percentage/ {print $2}' | tr -d %)"
        if [ "$charge" -ge 20 ]; then
          ${pkgs.eww}/bin/eww update battery_icon_type=0
        elif [ "$charge" -ge 10 ]; then
          ${pkgs.eww}/bin/eww update battery_icon_type=1
        elif [ "$charge" -lt 10 ]; then
          ${pkgs.eww}/bin/eww update battery_icon_type=2
        fi

      if [ "$1" == 'charge' ]; then
        ${pkgs.upower}/bin/upower -i /org/freedesktop/UPower/devices/battery_BAT1 | ${pkgs.gawk}/bin/awk '/percentage/ {print $2}' | tr -d %
      elif [ "$1" == 'time' ]; then
        info="$(${pkgs.upower}/bin/upower -i /org/freedesktop/UPower/devices/battery_BAT1 | ${pkgs.gawk}/bin/awk '/time to/ {print $3 $4 " " $5}')"
        time="$(${pkgs.coreutils}/bin/echo $info | ${pkgs.coreutils}/bin/cut -d':' -f2)"
        # if discharging
        if [[ "$info" =~ 'empty' ]]; then
            ${pkgs.coreutils}/bin/echo "$time remaining"
        # if charging
        elif [[ "$info" =~ 'full' ]]; then
            ${pkgs.coreutils}/bin/echo "$time remaining until full charge"
        else
            ${pkgs.coreutils}/bin/echo 'Calculating time remaining...'
        fi
      elif [ "$1" == 'status' ]; then
        ${pkgs.upower}/bin/upower -i /org/freedesktop/UPower/devices/battery_BAT1 | ${pkgs.gawk}/bin/awk '/state/ {print $2}'
      elif [ "$1" == 'icon' ]; then
        status="$(${pkgs.upower}/bin/upower -i /org/freedesktop/UPower/devices/battery_BAT1 | ${pkgs.gawk}/bin/awk '/state/ {print $2}')"
        [ "$status" != 'charging' ] && charge="$(${pkgs.upower}/bin/upower -i /org/freedesktop/UPower/devices/battery_BAT1 | ${pkgs.gawk}/bin/awk '/percentage/ {print $2}' | tr -d %)"
        if [ "$status" == 'charging' ]; then
          ${pkgs.coreutils}/bin/echo '󰂄'
          ${pkgs.eww}/bin/eww update battery_icon_type=0
        elif [ "$charge" -eq 100 ]; then
          ${pkgs.coreutils}/bin/echo '󰁹'
        elif [ "$charge" -ge 90 ]; then
          ${pkgs.coreutils}/bin/echo '󰂂'
        elif [ "$charge" -ge 80 ]; then
          ${pkgs.coreutils}/bin/echo '󰂁'
        elif [ "$charge" -ge 70 ]; then
          ${pkgs.coreutils}/bin/echo '󰂀'
        elif [ "$charge" -ge 60 ]; then
          ${pkgs.coreutils}/bin/echo '󰁿'
        elif [ "$charge" -ge 50 ]; then
          ${pkgs.coreutils}/bin/echo '󰁾'
        elif [ "$charge" -ge 40 ]; then
          ${pkgs.coreutils}/bin/echo '󰁽'
        elif [ "$charge" -ge 30 ]; then
          ${pkgs.coreutils}/bin/echo '󰁼'
        elif [ "$charge" -ge 20 ]; then
          ${pkgs.coreutils}/bin/echo '󰁻'
        elif [ "$charge" -ge 10 ]; then
          ${pkgs.coreutils}/bin/echo '󰁺'
        elif [ "$charge" -lt 10 ]; then
          ${pkgs.coreutils}/bin/echo '󰂃'
        fi
      fi
    '')

    # BUG: label can go above 100% if using volume keys
    # BUG: on first boot, there is no value
    (writeShellScriptBin "eww-volume" ''
      volume="$(${pkgs.wireplumber}/bin/wpctl get-volume @DEFAULT_AUDIO_SINK@ | ${pkgs.gawk}/bin/awk '{print $2 * 100}')"

      if [[ "$1" == 'toggle' ]]; then
          ${pkgs.wireplumber}/bin/wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle
      elif [[ "$1" == 'update-slider' ]]; then
          ${pkgs.eww}/bin/eww update volume_value_slider="$volume"
      else
          [ -n "$1" ] && ${pkgs.wireplumber}/bin/wpctl set-volume @DEFAULT_AUDIO_SINK@ "$1"
      fi

      # never go above 100%
      [ "$volume" -gt 100 ] && ${pkgs.wireplumber}/bin/wpctl set-volume @DEFAULT_AUDIO_SINK@ 100%

      [[ "$2" == 'update-slider' ]] && ${pkgs.eww}/bin/eww update volume_value_slider="$volume"

      ${pkgs.eww}/bin/eww update volume_value_label="$volume"

      [ "$(${pkgs.wireplumber}/bin/wpctl get-volume @DEFAULT_AUDIO_SINK@ | ${pkgs.coreutils}/bin/cut -d' ' -f3)" == '[MUTED]' ] && muted=1

      if [ -n "$muted" ]; then
          ${pkgs.eww}/bin/eww update volume_icon=''
      elif [ "$volume" -ge 60 ]; then
          ${pkgs.eww}/bin/eww update volume_icon=''
      elif [ "$volume" -ge 30 ]; then
          ${pkgs.eww}/bin/eww update volume_icon=''
      elif [ "$volume" -lt 30 ]; then
          ${pkgs.eww}/bin/eww update volume_icon=''
      fi
    '')

    (writeShellScriptBin "eww-brightness" ''
      # NOTE: installing light with the NixOS programs.light.enable option is necessary for this to work
      # because it applies udev rules granting access to members of the video group
      # (make sure your user is in the video group)

      # if given a number
      if [[ "$1" =~ '^[0-9]+$' ]]; then
          ${pkgs.light}/bin/light -S "$1"
          brightness="$1"
      elif [[ "$1" == 'plus' ]]; then
          # increase the brightness
          ${pkgs.light}/bin/light -A 10
      elif [[ "$1" == 'minus' ]]; then
          # decrease the brightness
          ${pkgs.light}/bin/light -U 10
      fi

      brightness="$(${pkgs.light}/bin/light -G)" &&
        brightness="''${brightness%%.*}" &&
        ${pkgs.eww}/bin/eww update brightness_value_slider="$brightness"

      ${pkgs.eww}/bin/eww update brightness_value_label="$brightness"

      if [ "$brightness" -ge 60 ]; then
          ${pkgs.eww}/bin/eww update brightness_icon='󰃠'
      elif [ "$brightness" -ge 33 ]; then
          ${pkgs.eww}/bin/eww update brightness_icon='󰃟'
      elif [ "$brightness" -lt 33 ]; then
          ${pkgs.eww}/bin/eww update brightness_icon='󰃞'
      fi

      # save the current brightness
      ${pkgs.light}/bin/light -O
    '')

    (writeShellScriptBin "eww-service" ''
      activity="$(systemctl --user is-active $1.service)"
      if [[ "$activity" == 'active' ]]; then
        systemctl --user stop $1.service
      elif [[ "$activity" == 'inactive' ]]; then
        systemctl --user start $1.service
      fi
    '')

    (writeShellScriptBin "eww-mullvad" ''
      status="$(${pkgs.mullvad}/bin/mullvad status | head -1)"
      if [[ "$status" == 'Disconnected' ]]; then
        ${pkgs.mullvad}/bin/mullvad connect && ${pkgs.libnotify}/bin/notify-send 'VPN' 'Connected'
      elif [[ "$status" =~ 'Connected' ]]; then
        ${pkgs.mullvad}/bin/mullvad disconnect && ${pkgs.libnotify}/bin/notify-send 'VPN' 'Disconnected'
      fi
    '')
  ];
}
