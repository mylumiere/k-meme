#!/bin/bash
# Reads active meme config and outputs its content
# Usage: get-enabled-memes.sh <plugin-data-dir> <memes-dir>

PLUGIN_DATA="${1:-$CLAUDE_PLUGIN_DATA}"
MEMES_DIR="${2:-$(dirname "$0")/../memes}"
CONFIG_FILE="$PLUGIN_DATA/config.json"

# If no config exists, no active meme
if [ ! -f "$CONFIG_FILE" ]; then
  echo "활성화된 밈이 없습니다."
  exit 0
fi

# Read active meme
ACTIVE=$(jq -r '.active // empty' "$CONFIG_FILE" 2>/dev/null)

if [ -z "$ACTIVE" ]; then
  echo "활성화된 밈이 없습니다."
  exit 0
fi

MEME_FILE="$MEMES_DIR/$ACTIVE.md"
if [ -f "$MEME_FILE" ]; then
  cat "$MEME_FILE"
else
  echo "활성 밈 파일을 찾을 수 없습니다: $ACTIVE"
  exit 1
fi
