#!/bin/bash

# V60 Recipe Icon Conversion Script
# Converts the high-resolution logo to all required icon sizes for web and PWA

set -e

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${BLUE}=======================================${NC}"
echo -e "${BLUE}V60 Recipe Icon Conversion Script${NC}"
echo -e "${BLUE}=======================================${NC}"
echo ""

# Check if ImageMagick is installed
if ! command -v convert &> /dev/null; then
    echo -e "${YELLOW}ImageMagick not found. Installing...${NC}"
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        sudo apt-get update && sudo apt-get install -y imagemagick
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        brew install imagemagick
    else
        echo "Please install ImageMagick manually: https://imagemagick.org/script/download.php"
        exit 1
    fi
fi

# Source directory and files
ICON_DIR="icons"
SOURCE_DARK="$ICON_DIR/V60-iOS-Dark-1024x1024@1x.png"
SOURCE_DEFAULT="$ICON_DIR/V60-iOS-Default-1024x1024@1x.png"
SOURCE_LOGO="$ICON_DIR/V60.icon/Assets/logo-transparent.png"

# Determine which source image to use (prefer default version)
if [ -f "$SOURCE_DEFAULT" ]; then
    SOURCE_IMAGE="$SOURCE_DEFAULT"
    echo -e "${GREEN}✓${NC} Using default theme logo: $SOURCE_DEFAULT"
elif [ -f "$SOURCE_DARK" ]; then
    SOURCE_IMAGE="$SOURCE_DARK"
    echo -e "${GREEN}✓${NC} Using dark theme logo: $SOURCE_DARK"
elif [ -f "$SOURCE_LOGO" ]; then
    SOURCE_IMAGE="$SOURCE_LOGO"
    echo -e "${GREEN}✓${NC} Using logo from icon.json: $SOURCE_LOGO"
else
    echo -e "${YELLOW}Error: No source logo found!${NC}"
    echo "Please ensure one of these files exists:"
    echo "  - $SOURCE_DARK"
    echo "  - $SOURCE_DEFAULT"
    echo "  - $SOURCE_LOGO"
    exit 1
fi

# Create icons directory if it doesn't exist
mkdir -p "$ICON_DIR"

echo ""
echo -e "${BLUE}Converting icons...${NC}"
echo ""

# Function to convert with proper quality and compression
convert_icon() {
    local size=$1
    local output=$2
    local purpose=$3

    if [ "$purpose" == "maskable" ]; then
        # For maskable icons, add 20% padding (safe zone)
        local padded_size=$((size * 80 / 100))
        convert "$SOURCE_IMAGE" \
            -resize "${padded_size}x${padded_size}" \
            -gravity center \
            -extent "${size}x${size}" \
            -background none \
            -quality 95 \
            "$output"
    else
        # Standard icons
        convert "$SOURCE_IMAGE" \
            -resize "${size}x${size}" \
            -quality 95 \
            "$output"
    fi

    echo -e "${GREEN}✓${NC} Created: $output (${size}x${size})"
}

# Generate PWA icons (standard)
convert_icon 192 "$ICON_DIR/icon-192.png" "standard"
convert_icon 512 "$ICON_DIR/icon-512.png" "standard"

# Generate PWA maskable icons (with safe zone padding)
convert_icon 192 "$ICON_DIR/icon-maskable-192.png" "maskable"
convert_icon 512 "$ICON_DIR/icon-maskable-512.png" "maskable"

# Generate Apple Touch Icon (180x180)
convert "$SOURCE_IMAGE" \
    -resize 180x180 \
    -quality 95 \
    "$ICON_DIR/apple-touch-icon.png"
echo -e "${GREEN}✓${NC} Created: $ICON_DIR/apple-touch-icon.png (180x180)"

# Generate Favicon (32x32 and 16x16 in ICO format)
echo ""
echo -e "${BLUE}Generating multi-resolution favicon.ico...${NC}"

# Create temporary PNG files for favicon
convert "$SOURCE_IMAGE" -resize 32x32 -quality 95 /tmp/favicon-32.png
convert "$SOURCE_IMAGE" -resize 16x16 -quality 95 /tmp/favicon-16.png

# Combine into ICO file
convert /tmp/favicon-32.png /tmp/favicon-16.png "$ICON_DIR/favicon.ico"
echo -e "${GREEN}✓${NC} Created: $ICON_DIR/favicon.ico (32x32, 16x16)"

# Clean up temporary files
rm -f /tmp/favicon-32.png /tmp/favicon-16.png

# Generate additional common sizes (optional, for completeness)
echo ""
echo -e "${BLUE}Generating additional icon sizes...${NC}"
convert_icon 72 "$ICON_DIR/icon-72.png" "standard"
convert_icon 96 "$ICON_DIR/icon-96.png" "standard"
convert_icon 128 "$ICON_DIR/icon-128.png" "standard"
convert_icon 144 "$ICON_DIR/icon-144.png" "standard"
convert_icon 152 "$ICON_DIR/icon-152.png" "standard"
convert_icon 384 "$ICON_DIR/icon-384.png" "standard"

echo ""
echo -e "${GREEN}=======================================${NC}"
echo -e "${GREEN}✓ Icon conversion complete!${NC}"
echo -e "${GREEN}=======================================${NC}"
echo ""
echo -e "Generated icons:"
echo -e "  • PWA icons: 192x192, 512x512"
echo -e "  • Maskable icons: 192x192, 512x512"
echo -e "  • Apple Touch Icon: 180x180"
echo -e "  • Favicon: 16x16, 32x32 (ICO)"
echo -e "  • Additional sizes: 72-384px"
echo ""
echo -e "${BLUE}Next steps:${NC}"
echo -e "  1. Review the generated icons in the '$ICON_DIR' directory"
echo -e "  2. Test the PWA manifest and favicon in your browser"
echo -e "  3. Verify icons appear correctly on iOS devices"
echo ""
