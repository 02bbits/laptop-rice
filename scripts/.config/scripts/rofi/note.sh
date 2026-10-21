#!/bin/bash
# Type a line, pick a category, append it to today's daily note via `note`

text=$(rofi -dmenu -config "$HOME/.config/rofi/minimal.rasi" \
    -theme-str 'window { width: 800px; } mainbox { children: [inputbar]; } inputbar { border: 0px; }' \
    -theme-str 'textbox-prompt { content: " "; }' \
    -theme-str 'entry { placeholder: "note for today"; }' </dev/null)
# one quoted value per -theme-str: rofi matches strings greedily, so two quotes on one line swallow everything between them
[[ -z "$text" ]] && exit

index=$(echo -e "none\n✅  done\n💡  idea\n📝  todo\n📚  learnt" | rofi \
    -dmenu -i -no-custom \
    -format i \
    -mesg "$(sed 's/&/\&amp;/g; s/</\&lt;/g; s/>/\&gt;/g' <<<"save item \"$text\" as:")" \
    -config "$HOME/.config/rofi/minimal-menu.rasi")
[[ -z "$index" ]] && exit

categories=(d i n l "")
printf '%s\n' "${categories[$index]}" | "$HOME/.config/scripts/user/note" -- "$text"
notify-send -u low "Note" "$text"
