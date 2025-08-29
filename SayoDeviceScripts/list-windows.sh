#!/usr/bin/env bash
# ~/scripts/list-windows.sh  — XWayland fallback (WM_CLASS<TAB>TITLE)
set -euo pipefail
echo -e "WM_CLASS\tTITLE"
wmctrl -l | awk '{print $1}' | while read -r wid; do
  cls="$(xprop -id "$wid" WM_CLASS 2>/dev/null | awk -F\" '{print $(NF-1)}')"
  ttl="$(xprop -id "$wid" WM_NAME  2>/dev/null | sed -E 's/.*= "(.*)"/\1/')"
  [[ -n "$cls$ttl" ]] && printf "%s\t%s\n" "${cls:-}" "${ttl:-}"
done

