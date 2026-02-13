# Quick Icon Reference

## 🎨 Your New Logo is Now Live!

All icons have been generated from your V60 iOS Icon Composer design and are integrated throughout the project.

## 📁 Key Files

- **Conversion Script**: [`convert-icons.sh`](convert-icons.sh) - Regenerate all icons
- **Icon Preview**: [`icon-preview.html`](icon-preview.html) - Visual preview of all icons
- **Icon Documentation**: [`icons/README.md`](icons/README.md) - Detailed icon management
- **Integration Summary**: [`ICON-INTEGRATION.md`](ICON-INTEGRATION.md) - Complete implementation details

## 🖼️ Source Images

Your new logo design is sourced from:
- **Dark theme** (currently used): `icons/V60-iOS-Dark-1024x1024@1x.png`
- **Light theme** (backup): `icons/V60-iOS-Default-1024x1024@1x.png`
- **Icon Composer**: `icons/V60.icon/Assets/logo-transparent.png`

## ✅ What's Been Done

1. ✅ Generated all PWA icons (72px - 512px)
2. ✅ Created maskable icons with safe zone padding
3. ✅ Generated iOS Apple Touch Icon (180×180)
4. ✅ Created multi-resolution favicon (16×16, 32×32)
5. ✅ Updated `manifest.json` with all icon sizes
6. ✅ Verified `index.html` icon references
7. ✅ Created conversion script for future updates
8. ✅ Added comprehensive documentation

## 🚀 Preview Your Icons

Open [`icon-preview.html`](icon-preview.html) in your browser to see all icons with different mask shapes.

## 🔄 Updating Icons in the Future

If you update your logo design:

```bash
# 1. Replace the source image(s) in icons/ directory
# 2. Run the conversion script
./convert-icons.sh

# 3. Preview the results
open icon-preview.html
```

## 📱 Where Icons Are Used

- **PWA Manifest** ([manifest.json](manifest.json)): All icon sizes for Android/Chrome
- **HTML Head** ([index.html](index.html)): Favicon and Apple Touch Icon
- **Service Worker** ([sw.js](sw.js)): Cached for offline use

## 🎯 Icon Specifications

| Type | Size | Purpose | File |
|------|------|---------|------|
| PWA Standard | 72-512px | General use | `icon-{size}.png` |
| PWA Maskable | 192, 512px | Adaptive icons | `icon-maskable-{size}.png` |
| iOS | 180×180 | Home screen | `apple-touch-icon.png` |
| Favicon | 16, 32px | Browser tabs | `favicon.ico` |

## 🎨 Design Details

- **Theme**: Dark coffee brown (#3E2723)
- **Illustration**: Cream-colored V60 pour-over dripper
- **Style**: Minimalist, modern, warm
- **Safe Zone**: 20% padding on maskable icons

---

**Need help?** Check the detailed documentation in [ICON-INTEGRATION.md](ICON-INTEGRATION.md)
