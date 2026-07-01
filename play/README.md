# Play Sports Heads locally

## Option A — Ruffle desktop (recommended)

From the repo root:

```bat
play\play.bat
```

This launches `tools\ruffle\ruffle.exe` with `original\sports_heads_football_championship.swf`.

You can also drag the SWF onto `tools\ruffle\ruffle.exe`.

## Option B — Browser via Ruffle

Open `play\index.html` in Chrome, Firefox, or Edge. The page loads Ruffle from the official CDN and embeds the local SWF.

> Some browsers block `file://` fetches. If the game does not load, use Option A or serve the repo with a local HTTP server.

## Option C — Adobe Flash Player projector (fallback)

For pixel-perfect original behavior, use the archived standalone player `flashplayer_32_sa.exe`:

```bat
flashplayer_32_sa.exe "..\original\sports_heads_football_championship.swf"
```

Download from Internet Archive mirrors if you do not already have it. Adobe no longer distributes Flash Player.

## Controls

From decompiled `MainTimeline.as` (single-player):

| Key | Action |
|-----|--------|
| Left / Right | Move |
| Up | Jump |
| Space | Kick / dismiss pre-match briefer |

Two-player mode uses additional bindings in the same file (search `TwoPlayers` and `key.isDown`).

## Troubleshooting

| Issue | Fix |
|-------|-----|
| Ruffle window is blank | Try Flash projector; some AS3 + Box2D edge cases differ in Ruffle |
| No sound | Check Ruffle audio settings; ensure system volume is up |
| High-score submit fails | Expected offline — scores POST to mousebreaker.com only on frame 40 |
| Save progress missing | Ruffle SharedObject support may differ from Flash Player |
