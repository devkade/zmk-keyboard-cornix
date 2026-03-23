#!/bin/bash

# ZMK Build Script for Cornix Keyboard

set -e # Exit on any error

echo "Building ZMK firmware for Cornix keyboard..."

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ZMK_CONFIG_DIR="${ZMK_CONFIG:-$SCRIPT_DIR}"

echo "Using ZMK config: $ZMK_CONFIG_DIR"

if [[ ! -d "$ZMK_CONFIG_DIR" ]]; then
  echo "Error: ZMK config directory does not exist: $ZMK_CONFIG_DIR" >&2
  exit 1
fi

KEYMAP_FILE_PATH="${KEYMAP_FILE_PATH:-$SCRIPT_DIR/config/cornix.keymap}"

echo "Using keymap file for left/right builds: $KEYMAP_FILE_PATH"

if [[ ! -f "$KEYMAP_FILE_PATH" ]]; then
  echo "Error: Keymap file does not exist: $KEYMAP_FILE_PATH" >&2
  exit 1
fi

# Clean previous builds to ensure fresh build
echo "Cleaning previous build directories..."
rm -rf build/reset build/right build/left

# Build reset firmware
echo "Building reset firmware..."
west build -s zmk/app -b cornix_right -d build/reset -- -DZMK_CONFIG="$ZMK_CONFIG_DIR" -DSHIELD=settings_reset

# Build right half
echo "Building right half..."
west build -s zmk/app -b cornix_right -d build/right -- -DZMK_CONFIG="$ZMK_CONFIG_DIR" -DKEYMAP_FILE="$KEYMAP_FILE_PATH"
# Build left half
echo "Building left half..."
west build -s zmk/app -b cornix_left -d build/left -- -DZMK_CONFIG="$ZMK_CONFIG_DIR" -DKEYMAP_FILE="$KEYMAP_FILE_PATH"

echo "All builds completed successfully!"
echo "Firmware files are located in:"
echo "  - build/reset/zephyr/zmk.uf2"
echo "  - build/right/zephyr/zmk.uf2"
echo "  - build/left/zephyr/zmk.uf2"
