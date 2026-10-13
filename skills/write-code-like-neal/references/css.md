# CSS Code Style Guidelines

## Color
- Define all colors as CSS custom properties on `:root` (e.g. `--fg`, `--bg`, `--muted`, `--line`, `--accent`). Never hardcode color values inline or scattered across selectors.
- Support dark mode via `@media (prefers-color-scheme: dark)` redefining the same custom properties. Don't build a separate stylesheet or a JS-driven toggle unless asked.
- Prefer soft color schemes over stark, high-contrast ones:
  - Avoid pure `#fff` backgrounds and pure `#000` text. Use warm off-whites/creams for light backgrounds and softened darks for dark mode.
  - Aim for comfortable reading contrast, not maximal contrast.

## Typography
- Establish a real type scale: headings, body text, and secondary/muted text should be visibly distinct sizes, not all the same.
- Use a comfortable line-height for body text (1.4-1.6).
- Label-style text (table headers, section labels, eyebrows) reads best small, uppercase, letter-spaced, and in the muted color, rather than matching body weight/size.

## Spacing
- Pick a spacing scale (e.g. multiples of 4px or 8px) and use only those values, rather than one-off pixel/rem numbers chosen per element.

## Data & Tables
- Numeric columns should use `font-variant-numeric: tabular-nums` so values align vertically.
- Right-align numeric columns; left-align labels.

## Precedence
These are defaults for when no stronger design direction is given. Always defer to explicit user instructions or an existing design system in the project over these defaults.
