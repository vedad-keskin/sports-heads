# Decompiled architecture map

Export from `sports_heads_football_championship.swf` (Flash 9, AS3, 800×540, Box2D physics).

## Entry points

| Role | Class / symbol | Path |
|------|----------------|------|
| Document root / game controller | `SPL_dist1_fla.MainTimeline` | `scripts/SPL_dist1_fla/MainTimeline.as` |
| Keyboard input | `KeyPoll` | `scripts/KeyPoll.as` |
| Physics world setup | `MainTimeline.resetWorld()`, `initLevel()` | same file |
| Box2D helpers | `Box2D.B2DManager` | `scripts/Box2D/B2DManager.as` |
| Utilities / site checks | `Utils` | `scripts/Utils.as` (grep for `Utils.init`) |
| Contact / collision callbacks | `myContactListener` | referenced in `MainTimeline.resetWorld()` |

## Timeline frames (MainTimeline)

Frame scripts drive menus and game states:

| Frame | Purpose (approx.) |
|-------|-------------------|
| 1 | Bootstrap: `KeyPoll`, league data, achievements, fixtures |
| 2–5 | Menus / loading |
| 14 | In-game state |
| 23 | Match flow |
| 32 | Results |
| 40–41 | High-score submit to mousebreaker.com (network; optional) |

Key methods:

- `frame1()` — creates `key = new KeyPoll(stage)`, initializes league/upgrade arrays
- `initGame()` — pause, briefer overlay, time mode setup
- `initLevel()` — spawns Box2D bodies (walls, ball, hero, opp, rackets, goals)
- `resetWorld()` — new `b2World`, gravity `(0, 300)`, contact listener
- `newGame()` — resets scores, loads SharedObject achievements

## Gameplay entities

| Entity | AS class | Box2D spawn (in `initLevel`) |
|--------|----------|------------------------------|
| Player head | `Hero` | `spawnFixedRotCircleBody` @ (600, 440) |
| Player foot/racket | `Racket` | revolute joint to hero |
| AI opponent | `Opp` | @ (200, 440) |
| AI racket | `OppRacket` | revolute joint to opp |
| Ball | `Ball` | `spawnCircleBody` @ (400, 230) |
| Ground | `GroundBlock` | bottom platform |
| Walls / goals | `InvisBlock`, etc. | angled box bodies |

Power-ups: `PU_*` classes (`PU_Speed_Good`, `PU_Bombs_Bad`, …) and `SPL_dist1_fla.PUHandler_110`.

## Input handling

`KeyPoll` stores a 256-key bitmap on the stage:

```as3
key = new KeyPoll(this.stage);
// ...
if (key.isDown(Keyboard.LEFT)) { ... }
if (key.isDown(Keyboard.SPACE)) { ... }  // dismiss briefer / start level
```

Search `MainTimeline.as` for `key.isDown` to map all bindings.

## Persistence

Flash `SharedObject` stores achievements, face/team selection, league progress (`mySharedObject.data.*` in MainTimeline).

## External dependencies

- **Embedded:** Box2D port, Mochi analytics stub (`mochi.as3`), assets via `[Embed(source="/_assets/assets.swf")]`
- **Network (optional):** `URLRequest` POST to `mousebreaker.com/.../highscores_...php` on frame 40 — fails silently offline

## Asset export summary

| Folder | Count | Contents |
|--------|-------|----------|
| `scripts/` | 224 | ActionScript classes |
| `sprites/` | 874 | Sprite definitions |
| `shapes/` | 197 | Vector shapes |
| `images/` | 37 | Bitmaps |
| `sounds/` | 12 | Audio |
| `texts/` | 189 | Static text fields |
| `fonts/` | 7 | Font definitions |
| `frames/` | 41 | Timeline frame exports |

## Suggested bugfix search targets

| Symptom | Where to look |
|---------|---------------|
| Physics / collision | `initLevel`, `myContactListener`, `B2DManager` |
| Player movement | `MainTimeline` + `key.isDown` in frame 14 loop |
| AI behavior | `Opp` / opponent update logic in MainTimeline |
| Power-ups | `PUHandler_110.as`, `PU_*.as` |
| Score / timer | `Counter_116`, `score_mc_115`, `timeLeft` vars |
| Menu / league | `frame1` fixture arrays, `LeagueItemClip` |
| Ruffle-specific | SharedObject, text input, networking APIs |

## Patch workflow reminder

Edit inside FFDec on the SWF file; save to `build/patched.swf`. Re-exporting scripts alone is for reading — recompiling all `.as` files back into a working SWF is unreliable.
