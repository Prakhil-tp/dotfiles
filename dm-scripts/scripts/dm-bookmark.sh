#!/bin/sh
# script to bookmar selected text

bookmark="$(xclip -o)"
file="$HOME/.local/share/script-files/snippets.txt"

if grep -q "^$bookmark$" "$file"; then
  notify-send "Oops." "Already bookmarked"
else
  short="$(echo "$bookmark" | cut -c1-60)..."
  desc="$(echo | dmenu -p "Desc for: $short")"
  [ -z "$desc" ] && notify-send "Cancelled" "No description given" && exit 1
  echo "$bookmark | $desc" >> "$file"
  notify-send "Bookmark added!" "$bookmark is now saved to the file"
fi
