#!/bin/bash
# Installs the native messaging host for Chrome
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
HOST_NAME="com.tabbar.toggle"
HOST_SCRIPT="$SCRIPT_DIR/toggle-tabbar.sh"
MANIFEST_DIR="$HOME/Library/Application Support/Google/Chrome/NativeMessagingHosts"
MANIFEST_PATH="$MANIFEST_DIR/$HOST_NAME.json"

# Get the extension ID from Chrome (user must provide or we use wildcard)
EXTENSION_ID="${1:-}"

if [ -z "$EXTENSION_ID" ]; then
  echo "Usage: ./install.sh <extension-id>"
  echo ""
  echo "To find your extension ID:"
  echo "  1. Go to chrome://extensions"
  echo "  2. Enable Developer mode"
  echo "  3. Copy the ID of 'Toggle Vertical Tabs'"
  exit 1
fi

mkdir -p "$MANIFEST_DIR"

cat > "$MANIFEST_PATH" <<EOF
{
  "name": "$HOST_NAME",
  "description": "Toggle Chrome vertical tab bar via AppleScript",
  "path": "$HOST_SCRIPT",
  "type": "stdio",
  "allowed_origins": ["chrome-extension://$EXTENSION_ID/"]
}
EOF

echo "Installed native messaging host:"
echo "  Manifest: $MANIFEST_PATH"
echo "  Script:   $HOST_SCRIPT"
echo "  Extension: $EXTENSION_ID"
echo ""
echo "Make sure System Settings > Privacy & Security > Accessibility"
echo "has your terminal (or Chrome) enabled."
