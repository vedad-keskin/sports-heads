param(
    [switch]$UseLocalRuffle
)

$ErrorActionPreference = "Stop"

$Root = Split-Path $PSScriptRoot -Parent
$StagingRoot = Join-Path $PSScriptRoot "staging"
$DistDir = Join-Path $PSScriptRoot "dist"
$GameName = "Sports Heads Football Championship Remastered"
$StageDir = Join-Path $StagingRoot $GameName
$SwfSource = Join-Path $Root "build\60fps_patch1.swf"
$LogoSource = Join-Path $Root "logo.png"
$ZipName = "SportsHeadsRemastered-Portable.zip"
$VersionFile = Join-Path $PSScriptRoot "ruffle-version.json"

function Write-LauncherBat {
    param([string]$Path)
    @"
@echo off
cd /d "%~dp0"
start "" "%~dp0ruffle\ruffle.exe" "%~dp0game\SportsHeads.swf"
"@ | Set-Content -Path $Path -Encoding ASCII
}

function Write-ReadmeTxt {
    param([string]$Path)
    @"
Sports Heads Football Championship Remastered
============================================

How to play
-----------
1. Extract this entire folder anywhere (Desktop, USB drive, etc.).
2. Double-click "Play Game.bat".
3. Enjoy.

Controls (single player)
------------------------
Left / Right  Move
Up            Jump
Space         Kick / dismiss pre-match briefer

Two-player mode uses extra keys in the game setup screen.

Troubleshooting
---------------
- Blank window: make sure the whole folder was extracted; do not run only the .bat from inside the zip.
- No sound: check Windows volume and Ruffle audio settings in the game window.
- Saves: progress is stored locally by Ruffle; keep this folder in the same place if you want saves to persist.

Includes Ruffle (Flash emulator) and a 60 FPS patched SWF.
See THIRD_PARTY.txt for Ruffle license information.
"@ | Set-Content -Path $Path -Encoding UTF8
}

function Write-ThirdPartyTxt {
    param(
        [string]$Path,
        [string]$RuffleTag
    )
    @"
Third-party software
====================

Ruffle Flash emulator
- Project: https://ruffle.rs
- Source:  https://github.com/ruffle-rs/ruffle
- Version: $RuffleTag
- License: Apache License 2.0 / MIT License (dual licensed)

Ruffle is included so this game can run without Adobe Flash Player.
"@ | Set-Content -Path $Path -Encoding UTF8
}

if (-not (Test-Path $SwfSource)) {
    Write-Error "Missing patched SWF: $SwfSource`nRun scripts\build-60fps.bat first."
}

Write-Host "Preparing staging folder ..."
if (Test-Path $StageDir) {
    Remove-Item -Recurse -Force $StageDir
}
New-Item -ItemType Directory -Force -Path (Join-Path $StageDir "game") | Out-Null
New-Item -ItemType Directory -Force -Path (Join-Path $StageDir "ruffle") | Out-Null

$ruffleTag = "local"
$ruffleSourceDir = $null

if ($UseLocalRuffle) {
    $localRuffle = Join-Path $Root "tools\ruffle\ruffle.exe"
    if (-not (Test-Path $localRuffle)) {
        Write-Error "Local Ruffle not found at $localRuffle"
    }
    $ruffleSourceDir = Split-Path $localRuffle -Parent
    $ruffleTag = "local (tools/ruffle)"
    Write-Host "Using local Ruffle from tools\ruffle\"
} else {
    Write-Host "Downloading latest Ruffle nightly ..."
    $ruffleInfo = & (Join-Path $PSScriptRoot "download-ruffle.ps1") -OutputDir (Join-Path $PSScriptRoot "ruffle-download") -VersionFile $VersionFile
    $ruffleSourceDir = $ruffleInfo.SourceDir
    $ruffleTag = $ruffleInfo.Tag
}

Copy-Item -Path (Join-Path $ruffleSourceDir "ruffle.exe") -Destination (Join-Path $StageDir "ruffle\ruffle.exe") -Force
$licensePath = Join-Path $ruffleSourceDir "LICENSE.md"
if (Test-Path $licensePath) {
    Copy-Item -Path $licensePath -Destination (Join-Path $StageDir "ruffle\LICENSE.md") -Force
}
Copy-Item -Path $SwfSource -Destination (Join-Path $StageDir "game\SportsHeads.swf") -Force
Copy-Item -Path $LogoSource -Destination (Join-Path $StageDir "logo.png") -Force

Write-LauncherBat -Path (Join-Path $StageDir "Play Game.bat")
Write-ReadmeTxt -Path (Join-Path $StageDir "README.txt")
Write-ThirdPartyTxt -Path (Join-Path $StageDir "THIRD_PARTY.txt") -RuffleTag $ruffleTag

New-Item -ItemType Directory -Force -Path $DistDir | Out-Null
$zipPath = Join-Path $DistDir $ZipName
if (Test-Path $zipPath) {
    Remove-Item -Force $zipPath
}

Write-Host "Creating $ZipName ..."
Compress-Archive -Path $StageDir -DestinationPath $zipPath -CompressionLevel Optimal

$sizeMb = [math]::Round((Get-Item $zipPath).Length / 1MB, 1)
Write-Host ""
Write-Host "Done."
Write-Host "  ZIP: $zipPath"
Write-Host "  Size: ${sizeMb} MB"
Write-Host "  Ruffle: $ruffleTag"
Write-Host ""
Write-Host "Share the ZIP with friends. They extract it and double-click Play Game.bat."
