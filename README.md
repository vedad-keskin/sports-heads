# Sports Heads Football Championship Remastered

60 FPS remaster of the Flash game archived at [Internet Archive](https://archive.org/download/sports_heads_football_championship_flash), played through [Ruffle](https://ruffle.rs).

This repo holds the **patch source**, decompiled ActionScript reference, and scripts to build and share a portable Windows release.

## Quick start — play locally

Build the patched SWF (once):

```bat
scripts\build-60fps.bat
```

Play:

```bat
play\play.bat
```

Or open `play/index.html` in a browser (Ruffle via CDN).

## Share with friends — portable ZIP

Build a self-contained folder you can zip and send:

```bat
release\build-release.bat
```

Output: `release/dist/SportsHeadsRemastered-Portable.zip`

Friends extract it and double-click **Play Game.bat**. No install, Java, or dev tools required.

Use local Ruffle instead of downloading the latest nightly:

```bat
release\build-release.bat -UseLocalRuffle
```

## Project layout

```
sports-heads/
├── original/          # Untouched SWF from the archive (download once)
├── build/             # Patched SWFs (rebuild with scripts/build-60fps.bat)
├── decompiled/        # FFDec export: scripts, sprites, sounds, images, …
├── patches/           # Documented patch notes
├── play/              # Dev launch scripts and browser player
├── release/           # Portable ZIP build scripts
├── tools/             # FFDec, Ruffle (local, not committed as binaries)
├── scripts/           # Build and export helpers
└── logo.png           # Game logo
```

## Patches included in the remaster

| Patch | What it fixes |
|-------|----------------|
| [001](patches/001-pu-timer-fixes.md) | Power-up timer bugs |
| [002](patches/002-60fps-timing.md) | 60 FPS timing, physics, movement scaling |
| [003](patches/003-right-goal-2p-defaults.md) | Right goal + 2P defaults |
| Custom head | Ribery head injection in 60fps build |

## Decompile / re-export

Requires Java 17+ (`java -version`).

```bat
scripts\decompile.bat
```

Exports into `decompiled/` using [JPEXS FFDec](https://github.com/jindrapetrik/jpexs-decompiler).

## Game tech stack (from decompilation)

| Layer | Details |
|-------|---------|
| Runtime | Flash 9, ActionScript 3 via Ruffle |
| Physics | Box2D (`decompiled/scripts/Box2D/`) |
| Document root | `SPL_dist1_fla.MainTimeline` |
| Input | `KeyPoll` (keyboard bitmap on stage) |
| Save data | `SharedObject` (local Flash storage) |

See [decompiled/ARCHITECTURE.md](decompiled/ARCHITECTURE.md) for class map and patch workflow.

## Tool versions (dev machine)

- Java: Eclipse Temurin 17
- FFDec: 26.2.1
- Ruffle: latest nightly (downloaded by `release/build-release.ps1`)
