#!/usr/bin/env bash
# Focus the Zoom *meeting* window and send Alt+<KEY> via ydotool.

set -Eeuo pipefail

KEY_CODE="${1:-}"; MOD_CODE="${2:-56}"  # 56 = KEY_LEFTALT
[[ -n "$KEY_CODE" ]] || { echo "Usage: $(basename "$0") <KEY_CODE> [MOD_CODE]" >&2; exit 2; }

# ---- Tunables ---------------------------------------------------------------
# Exact meeting titles to try first (colon-separated), then prefixes:
ZOOM_MEETING_TITLES="${ZOOM_MEETING_TITLES:-Meeting:Zoom Meeting}"
ZOOM_MEETING_PREFIXES="${ZOOM_MEETING_PREFIXES:-Meeting:Zoom Meeting}"
ZOOM_WM_CLASS="${ZOOM_WM_CLASS:-zoom}"
FOCUS_DELAY="${ZOOM_FOCUS_DELAY:-0.3}"
# ---------------------------------------------------------------------------

DB_DEST="org.gnome.Shell"
DB_PATH="/de/lucaswerkmeister/ActivateWindowByTitle"
DB_IFACE="de.lucaswerkmeister.ActivateWindowByTitle"

# Quote a string for GVariant (single-quoted). Handles embedded single quotes safely.
gvariant_quote() {
  # Turn:  foo's bar   ->  'foo'\''s bar'
  local s=$1
  printf "'%s'" "${s//\'/\047\'\047\047}"
}

# Call extension method with one string arg; return 0 iff reply starts with "(true"
call_activate() {
  local method="$1" arg="$2"
  local q; q=$(gvariant_quote "$arg")
  local out
  out="$(gdbus call --session \
          --dest "$DB_DEST" \
          --object-path "$DB_PATH" \
          --method "$DB_IFACE.$method" \
          "$q" 2>/dev/null || true)"
  [[ "$out" == "(true"* ]]
}

# Prefer most-recent matching window on current desktop.
gdbus call --session --dest "$DB_DEST" --object-path "$DB_PATH" \
  --method "$DB_IFACE.setSortOrder" 'highest_user_time' >/dev/null 2>&1 || true
gdbus call --session --dest "$DB_DEST" --object-path "$DB_PATH" \
  --method "$DB_IFACE.setCurrentDesktopFirst" true >/dev/null 2>&1 || true

focused=false

# 1) Exact titles
IFS=':' read -r -a TITLES <<< "$ZOOM_MEETING_TITLES"
for t in "${TITLES[@]}"; do
  [[ -z "$t" ]] && continue
  if call_activate "activateByTitle" "$t"; then
    focused=true; break
  fi
done

# 2) Title prefixes
if [[ "$focused" == false ]]; then
  IFS=':' read -r -a PREFIXES <<< "$ZOOM_MEETING_PREFIXES"
  for p in "${PREFIXES[@]}"; do
    [[ -z "$p" ]] && continue
    if call_activate "activateByPrefix" "$p"; then
      focused=true; break
    fi
  done
fi

# 3) Last resort: any Zoom window
if [[ "$focused" == false ]]; then
  call_activate "activateByWmClass" "$ZOOM_WM_CLASS" || true
fi

# Send Alt+<KEY>
sleep "$FOCUS_DELAY"
export YDOTOOL_SOCKET="${YDOTOOL_SOCKET:-/run/user/$(id -u)/ydotool.socket}"
/usr/local/bin/ydotool key "${MOD_CODE}:1" "${KEY_CODE}:1" "${KEY_CODE}:0" "${MOD_CODE}:0"

