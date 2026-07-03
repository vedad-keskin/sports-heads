# Play Sports Heads locally

## Ruffle desktop (recommended)

From the repo root:

```bat
play\play.bat
```

This launches `tools\ruffle\ruffle.exe` with the 60 FPS remastered SWF (`build/60fps_patch1.swf`).

Build or rebuild the patched SWF first:

```bat
scripts\build-60fps.bat
```

You can also drag the SWF onto `tools\ruffle\ruffle.exe`.

## Browser via Ruffle

Open `play/index.html` in Chrome, Firefox, or Edge. The page loads Ruffle from the official CDN and embeds the local SWF.

> Some browsers block `file://` fetches. If the game does not load, use the desktop launcher or serve the repo with a local HTTP server.

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
| Ruffle window is blank | Update Ruffle to the latest nightly from https://ruffle.rs/downloads |
| No sound | Check Ruffle audio settings; ensure system volume is up |
| High-score submit fails | Expected offline — scores POST to mousebreaker.com only on frame 40 |
| Save progress missing | Ruffle SharedObject support may differ from Flash Player |
