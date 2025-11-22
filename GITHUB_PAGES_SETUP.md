# GitHub Pages Setup for ModernOS

## Enable GitHub Pages

1. Go to your repository: https://github.com/A-Proof/ModernOS-Desktop

2. Click **Settings** (top right)

3. Scroll down to **Pages** (left sidebar)

4. Under **Source**, select:
   - Branch: `main`
   - Folder: `/docs`

5. Click **Save**

6. Wait 1-2 minutes for deployment

7. Your website will be live at:
   **https://a-proof.github.io/ModernOS-Desktop**

## What's Included

The website (`docs/index.html`) includes:

- ✅ Hero section with download button
- ✅ Feature showcase (6 cards)
- ✅ Comparison table (ModernOS vs macOS/Windows/Linux)
- ✅ Download section with license warning
- ✅ Responsive design (mobile-friendly)
- ✅ Modern gradient design
- ✅ Direct download link to ISO

## Customization

Edit `docs/index.html` to:
- Change colors (search for `#667eea` and `#764ba2`)
- Update download link
- Add more features
- Modify comparison table

## Testing Locally

```bash
# Open in browser
open docs/index.html

# Or use Python server
cd docs
python3 -m http.server 8000
# Visit: http://localhost:8000
```

## After Enabling

Your website will show:
- ModernOS branding
- Feature highlights
- Download button (links to GitHub release)
- License warning
- Comparison with other OSes

Users can download the ISO directly from the website!
