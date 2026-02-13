# Icon Management

This directory contains all icon assets for the V60 Recipe Calculator PWA.

## Source Files

- `V60-iOS-Dark-1024x1024@1x.png` - High-resolution logo with dark background (1024×1024)
- `V60-iOS-Default-1024x1024@1x.png` - High-resolution logo with light background (1024×1024)
- `V60.icon/` - Icon Composer project directory with source assets

## Generated Icons

The following icons are automatically generated from the source files using the `convert-icons.sh` script:

### PWA Icons

- `icon-192.png` (192×192) - Standard PWA icon
- `icon-512.png` (512×512) - Standard PWA icon
- `icon-maskable-192.png` (192×192) - Maskable icon with safe zone
- `icon-maskable-512.png` (512×512) - Maskable icon with safe zone

### iOS Icons

- `apple-touch-icon.png` (180×180) - iOS home screen icon

### Web Icons

- `favicon.ico` - Multi-resolution favicon (16×16, 32×32)
- Additional sizes: 72×72, 96×96, 128×128, 144×144, 152×152, 384×384

## Regenerating Icons

To regenerate all icons from the source files, run:

```bash
./convert-icons.sh
```

This script will:

1. Check for and install ImageMagick if needed
2. Convert the source logo to all required sizes
3. Generate maskable icons with proper safe zone padding
4. Create multi-resolution favicon
5. Optimize all images for web use

## Requirements

- **ImageMagick** - For image conversion (automatically installed by the script on Debian/Ubuntu or macOS)

## Icon Specifications

### Maskable Icons

Maskable icons include 20% padding (safe zone) to ensure the logo displays correctly on all devices, even when the system applies its own masking (e.g., rounded corners, squircle shapes).

### Color Schemes

- **Dark theme**: Coffee brown background (#3E2723) with cream-colored V60 illustration
- **Default theme**: Light brown background with V60 illustration

## Usage in Project

Icons are referenced in:

- `manifest.json` - PWA manifest for Android/Chrome
- `index.html` - Favicon and Apple Touch Icon references
