# Extracted source assets

Run from repo root:

```bat
scripts\extract-assets.bat
```

## Contents

| Path | Source | Count |
|------|--------|------:|
| `../audio/` | FFDec sound export from main SWF | 12 |
| `../sprites/images/` | FFDec image export (bitmaps) | 37 |
| `../../decompiled/sprites/` | Full sprite sheet export (874 PNG sequences) | 874 |
| `../../decompiled/fonts/` | Embedded fonts | 7 |
| `../../decompiled/shapes/` | Vector UI shapes (SVG) | 197 |

## Nested `assets.swf`

Gameplay MovieClips reference `[Embed(source="/_assets/assets.swf")]`. That library is embedded inside the main SWF; sprite/image exports above contain the visual data for Godot import.

Import PNGs into Godot: **Project → Import**, then assign to `Sprite2D` / `AnimatedSprite2D` scenes.

## Legal

Mousebreaker IP — local use only, do not redistribute.
