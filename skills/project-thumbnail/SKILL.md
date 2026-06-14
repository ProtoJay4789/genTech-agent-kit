---
name: project-thumbnail
description: Generate branded thumbnails for GitHub repos — consistent GenTech style
category: creative
---

# Project Thumbnail Generator

**Trigger:** When creating a new GitHub repo or when Jordan asks for a thumbnail.

## Steps

1. **Read the project** — Check README.md or main files to understand what it does
2. **Create HTML thumbnail** — Build at `/root/projects/[project]/thumbnail-gen.html`
3. **Screenshot** — Navigate to the file and take a screenshot
4. **Save** — Copy to `/root/projects/[project]/assets/thumbnail.png`
5. **Update README** — Add `![Alt](assets/thumbnail.png)` to the top
6. **Clean up** — Delete `thumbnail-gen.html`

## Thumbnail Structure

```html
<!-- Left side: Copy -->
- Brand tag with pulse
- Project name (bold)
- Subtitle (what it does)
- Feature pills
- CTA buttons
- Stats row

<!-- Right side: Dashboard mock -->
- Project preview (3D perspective)
- Key metrics
- Status indicators

<!-- Floating elements -->
- Feature badges
```

## Brand Consistency

- **Colors:** `#0a0e17` (bg), `#111827` (panel), `#00ff88` (accent)
- **Font:** Inter (Google Fonts)
- **Style:** Dark theme, clean, modern
- **Size:** 1200x630px (GitHub social preview)

## File Locations

- Template: `/root/projects/genTech-agent-kit/skills/project-thumbnail/`
- Output: `[project]/assets/thumbnail.png`
- README: Add to top of README.md

## Quality Checklist

- [ ] Brand tag visible
- [ ] Project name clear
- [ ] Subtitle explains what it does
- [ ] Stats show key metrics
- [ ] Mock shows project preview
- [ ] Floating badges add context
- [ ] 1200x630px dimensions
