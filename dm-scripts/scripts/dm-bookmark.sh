#!/bin/sh
# script to bookmar selected text

bookmark="$(xclip -o)"
file="$HOME/.local/share/script-files/snippets.txt"

if grep -q "^$bookmark$" "$file"; then
  notify-send "Oops." "Already bookmarked"
else
  echo "$bookmark" >> "$file"
  notify-send "Bookmark added!" "$bookmark is now saved to the file"
fi
