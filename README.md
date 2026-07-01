# Sports Heads Football Championship — Decompiled Archive

Reverse-engineering workspace for the Flash game archived at [Internet Archive](https://archive.org/download/sports_heads_football_championship_flash).

The original Mousebreaker FLA/source was never published. This repo holds the **decompiled ActionScript** and extracted assets from the SWF, plus tooling to play and patch the game locally.

## Project layout

```
sports-heads/
├── original/          # Untouched SWF from the archive
├── decompiled/        # FFDec export: scripts, sprites, sounds, images, …
├── build/             # Patched SWFs (future edits via FFDec)
├── play/              # Launch scripts and browser player
├── tools/             # FFDec, Ruffle (local, not committed as zips)
└── scripts/           # Repeatable export helpers
```

## Quick start — play locally

**Original (unpatched):**

```bat
play\play.bat
```

**Patched (ice + jump timer fixes):**

```bat
play\play-patched.bat
```

**Patched + 60 fps (~2× faster gameplay):**

```bat
play\play-60fps.bat
```

Or double-click `tools\ruffle\ruffle.exe` and open `build\patched_60fps.swf` or `build\patched.swf`.

**Browser (no install):** open `play\index.html` in a browser (uses Ruffle from CDN).

## Decompile / re-export

Requires Java 17+ (`java -version`).

```bat
scripts\decompile.bat
```

Exports into `decompiled/` using [JPEXS FFDec](https://github.com/jindrapetrik/jpexs-decompiler).

## Game tech stack (from decompilation)

| Layer | Details |
|-------|---------|
| Runtime | Flash 9, ActionScript 3 |
| Physics | Box2D (`decompiled/scripts/Box2D/`) |
| Document root | `SPL_dist1_fla.MainTimeline` |
| Input | `KeyPoll` (keyboard bitmap on stage) |
| Save data | `SharedObject` (local Flash storage) |
| External calls | High-score POST to mousebreaker.com (optional; game works offline) |

See [decompiled/ARCHITECTURE.md](decompiled/ARCHITECTURE.md) for class map and patch workflow.

## Patching bugs (future)

1. Open `original/sports_heads_football_championship.swf` in FFDec (`tools\ffdec\ffdec.bat`).
2. Edit ActionScript or P-code in the SWF (do not rely on recompiling exported `.as` files).
3. **File → Save as** → `build/patched.swf`.
4. Test with Ruffle and/or Adobe Flash Player standalone projector.

## Legal

Sports Heads is © Mousebreaker. Decompilation here is for personal preservation and learning. Do not redistribute modified SWFs or extracted assets without permission.

## Tool versions (installed locally)

- Java: Eclipse Temurin 17
- FFDec: 26.2.1
- Ruffle: 0.3.0
