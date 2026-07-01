# Godot 4 remake — Sports Heads Football Championship

Fixed-timestep physics + **real-time (delta) timers** so gameplay stays at original speed at 60+ FPS.

## Requirements

- [Godot Engine 4.3+](https://godotengine.org/download)

## Run

1. Open Godot → **Import** → select `remake/project.godot`
2. Press **F5** (main scene: `scenes/main.tscn`)

Or CLI:

```bat
godot --path remake
```

## Features implemented

| System | Status |
|--------|--------|
| Main menu (new / continue / 2P) | Done |
| 2P setup (timed, first to 7, golden gun; goal variants; pitch/head) | Done |
| League (20 teams, 61 matchdays, sim, team select) | Done |
| Upgrade shop | Done |
| Achievements (17) | Done |
| Match physics (hero/opp/ball, goals, timer) | Done |
| 18 power-ups (second-based timers) | Done |
| AI opponent (scaled by team rating + season) | Done |
| Save/load (`user://save.json`) | Done |
| Audio (extracted MP3 SFX + music) | Done |
| Pitch color themes (20 variants) | Done |
| Instructions | Done |

## Architecture

- **Render:** uncapped FPS (`application/run/max_fps=0`)
- **Physics:** 90 Hz (`physics/common/physics_ticks_per_second=90`)
- **Timers:** seconds via `GameConstants` (e.g. ice = 6.667 s, not 200 frames)

Key scripts:

- `scripts/match/match_controller.gd` — match loop
- `scripts/match/power_up_manager.gd` — all 18 PUs
- `scripts/league/league_manager.gd` — fixtures + simulation
- `scripts/autoload/save_manager.gd` — persistence

## Assets

Extract Flash assets:

```bat
scripts\extract-assets.bat
```

Imported audio: `assets/audio/`. Bitmaps: `assets/sprites/images/`. Full sprite export: `../decompiled/sprites/`.

## Tuning

Compare side-by-side with `build/patched.swf` and adjust in `scripts/autoload/game_constants.gd` (gravity, move accel, jump impulse, physics tick rate).

## Legal

Mousebreaker IP — local/personal use only.
