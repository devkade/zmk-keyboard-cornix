#!/bin/bash

# ZMK Build Script for Cornix Keyboard

set -e # Exit on any error

echo "Building ZMK firmware for Cornix keyboard..."

# Clean previous builds to ensure fresh build
echo "Cleaning previous build directories..."
rm -rf build/reset build/right build/left

# Build reset firmware
echo "Building reset firmware..."
west build -s zmk/app -b cornix_right -d build/reset -- -DZMK_CONFIG=/Users/kade/Areas/zmk-keyboard-cornix -DSHIELD=settings_reset

# Build right half
echo "Building right half..."
west build -s zmk/app -b cornix_right -d build/right -- -DZMK_CONFIG=/Users/kade/Areas/zmk-keyboard-cornix
# Build left half
echo "Building left half..."
west build -s zmk/app -b cornix_left -d build/left -- -DZMK_CONFIG=/Users/kade/Areas/zmk-keyboard-cornix

echo "All builds completed successfully!"
echo "Firmware files are located in:"
echo "  - build/reset/zephyr/zmk.uf2"
echo "  - build/right/zephyr/zmk.uf2"
echo "  - build/left/zephyr/zmk.uf2"
