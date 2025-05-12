#!/bin/sh
# script to bookmar selected text

bookmark="$(xclip -o)"
file="$HOME/.local/share/script-files/snippets.txt"

if grep -q "^$bookmark$" "$file"; then
  notify-send "Oops." "Already bookmarked"
else
  short_bookmark="$(echo "$bookmark" | cut -c1-80)…"
  description=$(echo "" | dmenu -p "Description for: $short_bookmark")
  [ -z "$description" ] && notify-send "Cancelled" "No description provided" && exit 1

  echo "$bookmark | $description" >> "$file"
  notify-send "Bookmark added!" "$bookmark is now saved to the file"
fi
