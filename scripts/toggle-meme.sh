#!/bin/bash
# Toggle a meme on/off in config (only one meme active at a time)
# Usage: toggle-meme.sh <action> <plugin-data-dir> <memes-dir> [meme-id]
# action: enable | disable | status

ACTION="$1"
PLUGIN_DATA="${2:-$CLAUDE_PLUGIN_DATA}"
MEMES_DIR="${3:-$(dirname "$0")/../memes}"
MEME_ID="$4"
CONFIG_FILE="$PLUGIN_DATA/config.json"
CUSTOM_DIR="$PLUGIN_DATA/custom-memes"

mkdir -p "$PLUGIN_DATA"
mkdir -p "$CUSTOM_DIR"

# Initialize config if missing
if [ ! -f "$CONFIG_FILE" ]; then
  echo '{ "active": null }' > "$CONFIG_FILE"
fi

# Helper: extract frontmatter field from a meme file
get_field() {
  local file="$1" field="$2"
  sed -n '/^---$/,/^---$/p' "$file" | grep "^${field}:" | sed "s/^${field}: *//"
}

# Helper: find meme file in built-in or custom dir
find_meme() {
  local id="$1"
  if [ -f "$CUSTOM_DIR/$id.md" ]; then
    echo "$CUSTOM_DIR/$id.md"
  elif [ -f "$MEMES_DIR/$id.md" ]; then
    echo "$MEMES_DIR/$id.md"
  fi
}

# Helper: collect all meme files from both dirs
all_meme_files() {
  ls "$MEMES_DIR"/*.md 2>/dev/null
  ls "$CUSTOM_DIR"/*.md 2>/dev/null
}

case "$ACTION" in
  enable)
    MEME_FILE=$(find_meme "$MEME_ID")
    if [ -z "$MEME_FILE" ]; then
      echo "ERROR: '$MEME_ID' 밈을 찾을 수 없습니다."
      echo "사용 가능한 밈:"
      all_meme_files | xargs -I{} basename {} .md
      exit 1
    fi
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

    # Collect memes from both dirs
    MEME_LIST=""
    SEEN_IDS=""
    for MEME_FILE in $(all_meme_files); do
      [ ! -f "$MEME_FILE" ] && continue
      ID=$(basename "$MEME_FILE" .md)
      # Skip duplicates (custom overrides built-in)
      echo "$SEEN_IDS" | grep -q "^${ID}$" && continue
      SEEN_IDS="${SEEN_IDS}${ID}\n"
      YEAR=$(get_field "$MEME_FILE" "year")
      DESC=$(get_field "$MEME_FILE" "description")
      YEAR=${YEAR:-"????"}
      # Mark custom memes
      IS_CUSTOM=""
      echo "$MEME_FILE" | grep -q "custom-memes" && IS_CUSTOM=" [커스텀]"
      MEME_LIST="${MEME_LIST}${YEAR}|${ID}|${DESC}${IS_CUSTOM}\n"
    done

    echo "=== k-meme 상태 ==="
    if [ -z "$ACTIVE" ]; then
      echo "활성 밈: 없음"
    else
      echo "활성 밈: $ACTIVE"
    fi
    echo ""

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
