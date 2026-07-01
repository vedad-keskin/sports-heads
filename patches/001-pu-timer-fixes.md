# Patch 001: Power-up timer fixes (Ice + Low Jump)

**Date:** 2026-07-01  
**Target:** `SPL_dist1_fla.PUHandler_110` in `original/sports_heads_football_championship.swf`  
**Output:** `build/patched.swf`

## Problem

Two copy-paste bugs in `PUHandler_110.gotOne()` when `ballSender == "hero"` (right player / arrow keys last touched the ball):

| Power-up | Wrong timer reset | Correct timer reset | Symptom |
|----------|-------------------|---------------------|---------|
| Ice Good (freeze left/opponent) | `oppPUSpeedTimer = 0` | `oppPUIceTimer = 0` | Left player stays frozen far too long |
| Jump Bad (weak jump on self) | `heroPUSpeedTimer = 0` | `heroPUJumpTimer = 0` | Right player weak jump never expires (~200 frames expected) |

The left-player branch (`ballSender == "opp"`) was already correct.

## Fix

In `gotOne()`, hero branch:

```diff
 else if(param2 is PU_Jump_Bad)
 {
    MovieClip(root).heroPUJump = 0;
-   heroPUSpeedTimer = 0;
+   heroPUJumpTimer = 0;
 }
 else if(param2 is PU_Ice_Good)
 {
    MovieClip(root).oppPUFreeze = true;
-   oppPUSpeedTimer = 0;
+   oppPUIceTimer = 0;
 }
```

## How applied

```bat
java -jar tools\ffdec\ffdec.jar -replace original\sports_heads_football_championship.swf build\patched.swf SPL_dist1_fla.PUHandler_110 decompiled\scripts\SPL_dist1_fla\PUHandler_110.as
```

## Test checklist (2P)

- [ ] Right collects Ice Good → left unfreezes after ~6–7 s
- [ ] Left collects Ice Good → right unfreezes after ~6–7 s (unchanged)
- [ ] Right collects Jump Bad → right jump returns to normal after ~6–7 s
- [ ] Left collects Jump Bad → left jump returns to normal after ~6–7 s (unchanged)
- [ ] No spurious speed reset when ice/jump debuffs are active

Launch: `tools\ruffle\ruffle.exe build\patched.swf`
