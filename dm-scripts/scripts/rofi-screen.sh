#!/usr/bin/env bash

LAYOUT_DIR="$HOME/.screenlayout/"

refresh_wm() {
  echo 'awesome.restart()' | awesome-client
}

menu_cmd() {
  rofi -dmenu -i -p "screen"
}

set_resolution() {
  monitor="$1"
  modes="$(xrandr | tr '\n' ' ' | grep -hoe "$monitor.\+" | grep -hoPe "\d+x\d+ ")"
  chosen_mode=$(echo -e "Auto\n${modes[@]}\nBack\nExit" | menu_cmd)
  if [ "$chosen_mode" == "Exit" ] || [ -z "$chosen_mode" ]; then 
    exit
  elif [ "$chosen_mode" != "Back" ]; then
    if [ "$chosen_mode" == "Auto" ]; then
      xrandr --output "$monitor" --auto
    else
      xrandr --output "$monitor" --mode "$chosen_mode"
    fi
  fi
}

set_position() {
  monitor="$1"
  positions="Above"
  positions+="\nBelow"
  positions+="\nLeft of"
  positions+="\nRight of"
  positions+="\nBack"
  chosen_position=$(echo -e "${positions[@]}" | menu_cmd)
  if [ "$chosen_position" == "Exit" ] || [ -z "$chosen_position" ]; then
    exit
  elif [ "$chosen_mode" != "Back" ]; then
    while true; do
      relative_monitor=$(echo "${monitors[@]} Back Exit" | tr ' ' '\n' | menu_cmd)
      if [ "$relative_monitor" != "$monitor" ]; then
        break
      fi
    done

    if [ "$relative_monitor" == "Exit" ] || [ -z "$relative_monitor" ]; then
      exit
    elif [ "$relative_monitor" == "Back" ]; then
      set_position "$chosen_monitor"
    else
      case "$chosen_position" in
        "Above")
          xrandr_switch="--above"
          ;;
        "Below")
          xrandr_switch="--below"
          ;;
        "Left of")
          xrandr_switch="--left-of"
          ;;
        "Right of")
          xrandr_switch="--right-of"
          ;;
      esac
      xrandr --output "$chosen_monitor" "$xrandr_switch" "$relative_monitor"
    fi
  fi
}

layouts_menu() {
  layouts_menu="Set layout"
  layouts_menu+="\nCreate new layout"
  layouts_menu+="\nDelete layout"
  layouts_menu+="\nSave current state as layout"
  layouts_menu+="\nBack"
  layouts_menu+="\nExit"
  chosen_layout_menu=$(echo -e "${layouts_menu[@]}" | menu_cmd)

  layouts=$(ls "$LAYOUT_DIR")

  if [ "$chosen_layout_menu" == "Exit" ] || [ -z "$chosen_layout_menu" ]; then
    exit
  elif [ "$chosen_layout_menu" != "Back" ]; then
    case "$chosen_layout_menu" in
      "Set layout")
        chosen_layout="$(echo -e "$layouts\nBack\nExit" | menu_cmd)"
        if [ "$chosen_layout" == "Exit" ] || [ -z "$chosen_layout" ]; then
          exit
        elif [ "$chosen_layout" == "Back" ]; then
          layouts_menu
        else
          source "$LAYOUT_DIR/$chosen_layout"
        fi
        ;;
      "Create new layout")
        while true; do
          layout_name="$(echo -e "Enter layout name\nBack\nExit" | menu_cmd)"
          if [ "$layout_name" == "Exit" ] || [ -z "$layout_name" ]; then
            exit
          elif [ "$layout_name" == "Back" ]; then
            layout_name
          elif [ "$layout_name" != "Enter layout name" ]; then
            break
          fi
        done

        echo "Creating layout"
        touch "$LAYOUT_DIR/$layout_name"
        chmod +x "$LAYOUT_DIR/$layout_name"
        ;;
      "Delete layout")
        chosen_layout="$(echo -e "$layouts\nBack\nExit" | menu_cmd)"
        if [ "$chosen_layout" == "Exit" ] || [ -z "$chosen_layout" ]; then
          exit
        elif [ "$chosen_layout" == "Back" ]; then
          layouts_menu
        else
          rm "$LAYOUT_DIR/$chosen_layout"
        fi
        ;;
      "Save current state as layout")
        echo "Saving current layout"

        target_layout="$(echo -e "$layouts\nBack\nExit" | menu_cmd)"
        if [ "$target_layout" == "Exit" ] || [ -z "$target_layout" ]; then
          exit
        elif [ "$target_layout" == "Back" ]; then
          layouts_menu
        else
          command_output="xrandr"

          i=0
          for part in $(xrandr --listactivemonitors | tail -n +2); do
            if (( i % 4 == 2 )); then
              width="${part%%/*}"
              height="${part%/*}"
              height="${height#*x}"
              mode_setting="$width"
              mode_setting+="x"
              mode_setting+="$height"
              command_output+=" --mode $mode_setting"

              pos="${part#*+}"
              pos=$(echo "$pos" | tr + x)
              command_output+=" --pos $pos"
            elif (( i % 4 == 1 )); then
              is_primary=0
              name="${part:1}"
              if [[ $(echo "$part" | grep -i '*') != "" ]]; then
                is_primary=1
                name="${part:2}"
              fi

              command_output+=" --output '$name'"
              if [ $is_primary == 1 ]; then
                command_output+=" --primary"
              fi
            fi
            i=$((i + 1))
          done

          echo $target_layout
          echo $command_output > "$LAYOUT_DIR/$target_layout"
        fi
        ;;
    esac
  fi
}

monitors="$(xrandr | grep -hoPe "[a-zA-Z]+[0-9-]+ connected" | grep -hoPe "[a-zA-Z]+[0-9-]+")"
monitors=($monitors)
menu="Make primary"
menu+="\nSet resolution"
if [ ${#monitors[@]} -ne 1 ]; then
  menu+="\nSet position"
fi
menu+="\nTurn off"
menu+="\nTurn on"
menu+="\nBack"
menu+="\nExit"

while true; do
  chosen_monitor=$(echo "${monitors[@]} Default Layouts Exit" | tr ' ' '\n' | menu_cmd)
  if [ "$chosen_monitor" == "Exit" ] || [ -z "$chosen_monitor" ]; then
    exit
  fi
  
  if [ "$chosen_monitor" == "Default" ]; then
    xrandr --auto
  elif [ "$chosen_monitor" == "Layouts" ]; then
    layouts_menu
  else
    chosen_menu=$(echo -e "${menu[@]}" | menu_cmd)
    case "$chosen_menu" in
      "Make primary")
        xrandr --output "$chosen_monitor" --primary 
        ;;
      "Set resolution")
        set_resolution "$chosen_monitor"
        ;;
      "Set position")
        set_position "$chosen_monitor"
        ;;
      "Turn off")
        xrandr --output "$chosen_monitor" --off 
        ;;
      "Turn on")
        xrandr --output "$chosen_monitor" --auto 
        ;;
      "Back")
        ;;
      *)
        exit
        ;;
    esac
    refresh_wm
  fi
done
