#!/bin/bash
# Toggle a meme on/off in config (only one meme active at a time)
# Usage: toggle-meme.sh <action> <plugin-data-dir> <memes-dir> [meme-id]
# action: enable | disable | status

ACTION="$1"
PLUGIN_DATA="${2:-$CLAUDE_PLUGIN_DATA}"
MEMES_DIR="${3:-$(dirname "$0")/../memes}"
MEME_ID="$4"
CONFIG_FILE="$PLUGIN_DATA/config.json"

mkdir -p "$PLUGIN_DATA"

# Initialize config if missing
if [ ! -f "$CONFIG_FILE" ]; then
  echo '{ "active": null }' > "$CONFIG_FILE"
fi

# Helper: extract frontmatter field from a meme file
get_field() {
  local file="$1" field="$2"
  sed -n '/^---$/,/^---$/p' "$file" | grep "^${field}:" | sed "s/^${field}: *//"
}

case "$ACTION" in
  enable)
    # Check meme exists
    if [ ! -f "$MEMES_DIR/$MEME_ID.md" ]; then
      echo "ERROR: '$MEME_ID' 밈을 찾을 수 없습니다."
      echo "사용 가능한 밈:"
      ls "$MEMES_DIR"/*.md 2>/dev/null | xargs -I{} basename {} .md
      exit 1
    fi
    # Set as the single active meme (replaces previous)
    jq --arg id "$MEME_ID" '.active = $id' "$CONFIG_FILE" > "$CONFIG_FILE.tmp" && mv "$CONFIG_FILE.tmp" "$CONFIG_FILE"
    echo "$MEME_ID 밈이 활성화되었습니다."
    ;;
  disable)
    CURRENT=$(jq -r '.active // empty' "$CONFIG_FILE" 2>/dev/null)
    if [ -z "$CURRENT" ]; then
      echo "현재 활성화된 밈이 없습니다."
    elif [ -n "$MEME_ID" ] && [ "$CURRENT" != "$MEME_ID" ]; then
      echo "'$MEME_ID'은(는) 현재 활성화된 밈이 아닙니다. 현재: $CURRENT"
    else
      jq '.active = null' "$CONFIG_FILE" > "$CONFIG_FILE.tmp" && mv "$CONFIG_FILE.tmp" "$CONFIG_FILE"
      echo "$CURRENT 밈이 비활성화되었습니다."
    fi
    ;;
  status)
    ACTIVE=$(jq -r '.active // empty' "$CONFIG_FILE" 2>/dev/null)

    # Collect memes with year and description, sort by year descending
    MEME_LIST=""
    for MEME_FILE in "$MEMES_DIR"/*.md; do
      [ ! -f "$MEME_FILE" ] && continue
      ID=$(basename "$MEME_FILE" .md)
      YEAR=$(get_field "$MEME_FILE" "year")
      DESC=$(get_field "$MEME_FILE" "description")
      YEAR=${YEAR:-"????"}
      MEME_LIST="${MEME_LIST}${YEAR}|${ID}|${DESC}\n"
    done

    echo "=== k-meme 상태 ==="
    if [ -z "$ACTIVE" ]; then
      echo "활성 밈: 없음"
    else
      echo "활성 밈: $ACTIVE"
    fi
    echo ""

    # Sort by year descending, then print
    echo -e "$MEME_LIST" | sort -t'|' -k1 -rn | while IFS='|' read -r YEAR ID DESC; do
      [ -z "$ID" ] && continue
      if [ "$ID" = "$ACTIVE" ]; then
        echo "  ● [$YEAR] $ID — $DESC"
      else
        echo "  ○ [$YEAR] $ID — $DESC"
      fi
    done
    ;;
  *)
    echo "Usage: toggle-meme.sh <enable|disable|status> <meme-id>"
    exit 1
    ;;
esac
