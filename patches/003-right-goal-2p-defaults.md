# Patch 003: Right goal movement + 2P menu defaults

**Date:** 2026-07-01  
**Target:** `SPL_dist1_fla.MainTimeline`, `SPL_dist1_fla.ChoosePlayer2P_75`  
**Output:** `build/60fps_patch1.swf` (via `scripts/build-60fps.bat`)

## 1. Right goal movement blocked

### Problem

Hero (right-side player) and 2P P2 could not move past **x = 720** when pressing right/D — the inner edge of the right crossbar. Left goal had no equivalent cap, so movement into the left goal worked normally.

### Fix

Removed `if (hero.GetPosition().x < 720)` and `if (opp.GetPosition().x < 720)` guards around rightward movement in `onFrame_game()`.

Also fixed `initLevel()` copy-paste bug: goal posts were placed with `SetXForm(body.GetPosition(), 0)` using the ceiling wedge body instead of explicit coordinates:

```as3
leftGoalPost.SetXForm(new b2Vec2(40, 345), 0);
rightGoalPost.SetXForm(new b2Vec2(760, 345), 0);
```

## 2. Two-player menu defaults

### Problem

2P setup randomized heads, pitch, and play type on first open (`ChoosePlayer2P_75` frame1).

### Fix

Fixed defaults (mapped from FFDec head symbol 316 frames):

| Setting | Variable | Value |
|---------|----------|-------|
| Player 1 head (bitmap 262) | `tpskin1` | **7** |
| Player 2 head (bitmap 258) | `tpskin2` | **3** |
| Clear pitch | `tpPitch` | **2** |
| First to seven | `tpGameType` | **1** |
| Regular goals | `tpSpecials` | **0** (unchanged) |

Changes in:
- `ChoosePlayer2P_75.as` frame1 — fixed init; removed `SPECIAL_HEADS` re-randomize of `tpskin2`
- `MainTimeline.as` frame1 — `tpGameType = 1`
- `MainTimeline.as` `TpbtnClicked()` — reset defaults when reopening 2P overlay

## How applied

```bat
scripts\build-60fps.bat
```

## Test checklist

**Right goal:**
- [ ] Enter right goal on ground — reach back like left goal
- [ ] Move along full crossbar toward right post
- [ ] Midfield still bounded by side walls

**2P defaults:**
- [ ] 2 Player menu shows P1 frame 7, P2 frame 3, clear pitch, first to seven
- [ ] Match uses first-to-7 scoring (no 60s timer)

Launch: `play\play.bat`
