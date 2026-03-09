---
name: favicon
description: Generates a complete set of favicons from a source image, including favicon.ico (16×16, 32×32, 48×48), apple-touch-icon (180×180), PWA manifest icons (192×192, 512×512), favicon-96x96.png, and optionally favicon.svg, then creates or updates site.webmanifest and injects the appropriate link tags into the project's HTML or layout file. Use when setting up or replacing favicons, a site icon, browser icon, or app icon for a web project — including requests involving favicon.ico, apple-touch-icon, PWA icons, or web app manifest icons across Rails, Next.js, static HTML, and other frameworks.
argument-hint: [path to source image]
---

Generate a complete set of favicons from the source image at `$1` and update the project's HTML with the appropriate link tags.

## Prerequisites

First, verify ImageMagick v7+ is installed by running:
```bash
which magick
```

If not found, stop and instruct the user to install it:
- **macOS**: `brew install imagemagick`
- **Linux**: `sudo apt install imagemagick`

## Step 1: Validate Source Image

1. Verify the source image exists at the provided path: `$1`
2. Check the file extension is a supported format (PNG, JPG, JPEG, SVG, WEBP, GIF)
3. If the file doesn't exist or isn't a valid image format, report the error and stop

Note whether the source is an SVG file - if so, it will also be copied as `favicon.svg`.

## Step 2: Detect Project Type and Static Assets Directory

The general pattern is: look for a framework config file, then use the corresponding static directory. Check in this order:

| Framework | Config File | Static Assets Directory |
|-----------|-------------|------------------------|
| **Rails** | `config/routes.rb` | `public/` |
| **Next.js** | `next.config.*` | `public/` |
| **Gatsby** | `gatsby-config.*` | `static/` |
| **SvelteKit** | `svelte.config.*` | `static/` |
| **Astro** | `astro.config.*` | `public/` |
| **Hugo** | `hugo.toml` / `config.toml` | `static/` |
| **Jekyll** | `_config.yml` | Root (same as `index.html`) |
| **Vite** | `vite.config.*` | `public/` |
| **Create React App** | `react-scripts` in `package.json` | `public/` |
| **Vue CLI** | `vue.config.*` | `public/` |
| **Angular** | `angular.json` | `src/assets/` |
| **Eleventy** | `.eleventy.js` / `eleventy.config.*` | Check `_site` output or root |
| **Static HTML** | `index.html` in root | Same directory as `index.html` |

**Important**: If existing favicon files are found (e.g., `favicon.ico`, `apple-touch-icon.png`), use their location as the target directory regardless of framework detection.

Report the detected project type and the static assets directory that will be used.

**When in doubt, ask**: If you are not 100% confident about where static assets should be placed, use `AskUserQuestionTool` to confirm the target directory before proceeding.

## Step 3: Determine App Name

Find the app name from these sources (in priority order):

1. **Existing `site.webmanifest`** — extract the `name` field
2. **`package.json`** — extract the `name` field
3. **Rails `config/application.rb`** — extract the module name (e.g., `module MyApp` → "MyApp")
4. **Directory name** — use the current working directory name as fallback

## Step 4: Ensure Static Assets Directory Exists

Check if the detected static assets directory exists. If not, create it.

## Step 5: Generate Favicon Files

Run these ImageMagick commands to generate all favicon files. Replace `[STATIC_DIR]` with the detected static assets directory from Step 2.

### favicon.ico (multi-resolution: 16x16, 32x32, 48x48)
```bash
magick "$1" \
  \( -clone 0 -resize 16x16 \) \
  \( -clone 0 -resize 32x32 \) \
  \( -clone 0 -resize 48x48 \) \
  -delete 0 -alpha on -background none \
  [STATIC_DIR]/favicon.ico
```

### favicon-96x96.png
```bash
magick "$1" -resize 96x96 -background none -alpha on [STATIC_DIR]/favicon-96x96.png
```

### apple-touch-icon.png (180x180)
```bash
magick "$1" -resize 180x180 -background none -alpha on [STATIC_DIR]/apple-touch-icon.png
```

### web-app-manifest-192x192.png
```bash
magick "$1" -resize 192x192 -background none -alpha on [STATIC_DIR]/web-app-manifest-192x192.png
```

### web-app-manifest-512x512.png
```bash
magick "$1" -resize 512x512 -background none -alpha on [STATIC_DIR]/web-app-manifest-512x512.png
```

### favicon.svg (only if source is SVG)
```bash
cp "$1" [STATIC_DIR]/favicon.svg
```

## Step 6: Create/Update site.webmanifest

Create or update `[STATIC_DIR]/site.webmanifest` with this content (substitute the detected app name):

```json
{
  "name": "[APP_NAME]",
  "short_name": "[APP_NAME]",
  "icons": [
    {
      "src": "/web-app-manifest-192x192.png",
      "sizes": "192x192",
      "type": "image/png",
      "purpose": "maskable"
    },
    {
      "src": "/web-app-manifest-512x512.png",
      "sizes": "512x512",
      "type": "image/png",
      "purpose": "maskable"
    }
  ],
  "theme_color": "#ffffff",
  "background_color": "#ffffff",
  "display": "standalone"
}
```

If `site.webmanifest` already exists, preserve the existing `theme_color`, `background_color`, and `display` values while updating `name`, `short_name`, and the `icons` array.

## Step 7: Update HTML/Layout Files

Adjust `href` paths based on how the static assets directory maps to the web root:
- `public/` or `static/` served from root → `/favicon.ico`
- `src/assets/` → `/assets/favicon.ico`
- Same directory as HTML → `favicon.ico`

### Standard HTML favicon tags

Used for Rails, Static HTML, Jekyll, Hugo, Eleventy, Gatsby, SvelteKit, and other HTML-based frameworks. Place near the top of `<head>` (after `<meta charset>` and `<meta name="viewport">` if present). Remove any existing `<link rel="icon"`, `<link rel="shortcut icon"`, `<link rel="apple-touch-icon"`, or `<link rel="manifest"` tags first.

```html
<link rel="icon" type="image/png" href="/favicon-96x96.png" sizes="96x96" />
<link rel="icon" type="image/svg+xml" href="/favicon.svg" />
<link rel="shortcut icon" href="/favicon.ico" />
<link rel="apple-touch-icon" sizes="180x180" href="/apple-touch-icon.png" />
<meta name="apple-mobile-web-app-title" content="[APP_NAME]" />
<link rel="manifest" href="/site.webmanifest" />
```

**If the source was NOT an SVG**, omit the `<link rel="icon" type="image/svg+xml" ...>` line.

| Project Type | File to edit |
|---|---|
| **Rails** | `app/views/layouts/application.html.erb` |
| **Static HTML** | Detected `index.html` |
| **Jekyll / Hugo / Eleventy / Gatsby / SvelteKit** | Theme or layout template containing `<head>` |

### For Next.js Projects

Edit the detected layout file (`app/layout.tsx` or `src/app/layout.tsx`). Update or add the `metadata` export:

```typescript
export const metadata: Metadata = {
  // ... keep existing metadata fields
  icons: {
    icon: [
      { url: '/favicon.ico' },
      { url: '/favicon-96x96.png', sizes: '96x96', type: 'image/png' },
      { url: '/favicon.svg', type: 'image/svg+xml' },
    ],
    shortcut: '/favicon.ico',
    apple: '/apple-touch-icon.png',
  },
  manifest: '/site.webmanifest',
  appleWebApp: {
    title: '[APP_NAME]',
  },
};
```

**If the source was NOT an SVG**, omit the `{ url: '/favicon.svg', type: 'image/svg+xml' }` entry. If the metadata export doesn't exist, create it with just the icons-related fields; if it exists, merge the icons configuration with existing fields.

### If No Project Detected

Skip HTML updates and inform the user to manually add the standard HTML favicon tags above to their `<head>`.

## Step 8: Summary

Report completion with:
- Detected project type and framework
- Static assets directory used
- List of files generated
- App name used in manifest and HTML
- Layout file updated (or note if manual update is needed)
- Note if any existing files were overwritten

## Error Handling

- If ImageMagick is not installed, provide installation instructions and stop
- If the source image doesn't exist, report the exact path that was tried and stop
- If ImageMagick commands fail, report the specific error message
- If the layout file cannot be found for HTML updates, generate files anyway and instruct on manual HTML addition
