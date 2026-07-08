#!/bin/bash
set -euo pipefail

# install.sh — Simple installer for odin-update (part of odin-doctor project)
#
# Copies the script to ~/bin/odin-update (your preferred location for CLI tools).
# Keeps it minimal per project rules. No complex prompts or PATH modifications.
#
# Usage: ./install.sh
#        (Run from project root)

SCRIPT_SRC="tools/odin-update"
TARGET_DIR="${HOME}/bin"
TARGET="${TARGET_DIR}/odin-update"

if [[ ! -f "$SCRIPT_SRC" ]]; then
    echo "ERROR: Source script not found at $SCRIPT_SRC"
    echo "Make sure you are in the odin-doctor project root."
    exit 1
fi

mkdir -p "$TARGET_DIR"

cp -f "$SCRIPT_SRC" "$TARGET"
chmod +x "$TARGET"

echo "✅ Installed odin-update to $TARGET"
echo ""
echo "Make sure $TARGET_DIR is in your PATH."
echo "On Linux/bash: usually already is (via ~/.bashrc)."
echo "On macOS/zsh: you may need to add 'export PATH=\"\$HOME/bin:\$PATH\"' to ~/.zshrc"
echo "and run 'source ~/.zshrc'."
echo ""
echo "Test with: odin-update --help"
