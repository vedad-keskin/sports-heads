# Patch 002: 60 FPS gameplay timing

**Date:** 2026-07-01  
**Target:** Multiple AS3 classes in `original/sports_heads_football_championship.swf`  
**Output:** `build/60fps_patch1.swf`

## Problem

The original Flash game runs at ~30 FPS with frame-locked logic. Raising the SWF frame rate to 60 without scaling timers, movement, or physics doubles gameplay speed (match clock, power-ups, AI ramp, etc.).

## Approach

1. Set SWF header frame rate to **60** via FFDec `-header -set framerate 60`.
2. Halve Box2D timestep: `1/96` → **`1/192`**, keep **3 steps per frame** (same sim time per wall second).
3. Double all frame-counter thresholds via `Utils.timingFrames(n)` (`FRAME_SCALE = 2`).
4. Halve per-frame movement values; use `Math.pow(0.7, 0.5)` and `Math.pow(0.8, 0.5)` for friction.
5. Include patch 001 PU timer bugfix in `PUHandler_110.gotOne()`.

## Timing helper

`decompiled/scripts/Utils.as` — added `FRAME_SCALE`, `MOVE_FRICTION`, `KICK_FRICTION`, and `timingFrames()` (merged into existing SWF class so FFDec `-replace` works without adding a new script).

## Modified classes

| Class | Changes |
|-------|---------|
| `Utils` | Added timing helper constants and `timingFrames()` |
| `SPL_dist1_fla.MainTimeline` | Physics timestep, movement, match clock, PU spawn, AI ramp, VFX throttle |
| `SPL_dist1_fla.PUHandler_110` | Doubled PU expiry thresholds + patch 001 |
| `TimeFunction` | Scales delay frames via `GameTiming.frames()` |
| `SPL_dist1_fla.score_mc_115` | Score overlay fade |
| `SPL_dist1_fla.Flasher_131` | Match-end flash timing |
| `Trail`, `Dust`, `Bomb` | Effect lifetimes |
| `SPL_dist1_fla.AchAward_17` | Achievement popup fade |

## How applied

```bat
scripts\build-60fps.bat
```

## Known limitations

- Timeline-based VFX (`Explosion`, `GreenRing`) still use embedded MovieClip frame counts and finish ~2× faster at 60 FPS.
- Menu timeline animations may play faster; gameplay logic is corrected.

## Test checklist

- [ ] Match clock counts down ~60 seconds
- [ ] Power-ups spawn every ~6.7 s; short effects ~6.7 s; bombs ~20 s; streaker ~33 s
- [ ] Ice/jump debuffs expire correctly (patch 001)
- [ ] Movement/jump feel matches 30 FPS baseline
- [ ] AI aggression ramp timing unchanged
- [ ] Ball physics feel equivalent
- [ ] Score overlay fade duration matches

Launch: `play\play.bat`
