# Design System Summary

## Design Philosophy

Inspired by apple.com and Apple's Human Interface Guidelines: calm, spacious, confident, and precise. No purple, no gradients, no heavy shadows.

## Color Palette

### Light Mode
| Token | Hex | Usage |
|-------|-----|-------|
| Background | `#FFFFFF` | Page background |
| Secondary Background | `#F5F5F7` | Grouped sections, input fills |
| Surface | `#FFFFFF` | Cards |
| Border | `#E8E8ED` | Hairline borders |
| Primary Text | `#1D1D1F` | Headlines, body |
| Secondary Text | `#6E6E73` | Subtitles, metadata |
| Tertiary Text | `#86868B` | Placeholders |
| Accent | `#0071E3` | Buttons, links, active states |

### Dark Mode
| Token | Hex | Usage |
|-------|-----|-------|
| Background | `#000000` | Page background |
| Secondary Background | `#1C1C1E` | Grouped sections |
| Surface | `#2C2C2E` | Elevated cards |
| Primary Text | `#F5F5F7` | Headlines, body |
| Accent | `#2997FF` | Buttons, links |

### Status Colors
| Status | Color | Hex |
|--------|-------|-----|
| Submitted | Orange | `#FF9F0A` |
| In Progress | Blue | `#0A84FF` |
| Resolved | Green | `#30D158` |
| Rejected | Gray | `#8E8E93` |

## Typography

| Style | Size | Weight | Use |
|-------|------|--------|-----|
| Large Title | 34pt | Bold (700) | Screen titles |
| Section Title | 22pt | Semibold (600) | Section headers |
| Headline | 20pt | Semibold (600) | Card titles |
| Body | 17pt | Regular (400) | Content text |
| Secondary | 15pt | Regular (400) | Subtitles |
| Caption | 13pt | Regular (400) | Metadata, timestamps |

Font stack: SF Pro (iOS system), fallback to system default on Android.

## Components

| Component | Shape | Details |
|-----------|-------|---------|
| Primary Button | Full-width pill, 50px tall | Accent fill, white text, 0.97 press scale |
| Secondary Button | Full-width pill, 50px tall | Gray fill, accent text |
| Text Field | Rounded rect, r=14 | Filled background, 1px border |
| Cards | Rounded rect, r=14 | Hairline border, no shadow |
| Bottom Sheet | Rounded top, r=20 | Grabber handle |
| Filter Pill | Full pill | Gray idle, black/accent when selected |
| Status Indicator | 8px dot + label text | Color-coded by status |
| Tab Bar | Frosted glass backdrop blur | 4 tabs with SF-style icons |

## Spacing
- Screen horizontal padding: 24px
- Section vertical spacing: 24-32px
- Component gap: 12-16px
- Min touch target: 44px
