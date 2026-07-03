param(
    [string]$OutputDir,
    [string]$VersionFile
)

$ErrorActionPreference = "Stop"

if (-not $OutputDir) {
    $OutputDir = Join-Path $PSScriptRoot "ruffle-download"
}

$releases = Invoke-RestMethod -Uri "https://api.github.com/repos/ruffle-rs/ruffle/releases?per_page=5"
$release = $releases | Where-Object { $_.tag_name -like "nightly-*" } | Select-Object -First 1

if (-not $release) {
    throw "Could not find a Ruffle nightly release on GitHub."
}

$asset = $release.assets | Where-Object { $_.name -eq "ruffle-nightly-$($release.tag_name -replace 'nightly-','' -replace '-','_')-windows-x86_64.zip" }
if (-not $asset) {
    $asset = $release.assets | Where-Object { $_.name -like "*windows-x86_64.zip" } | Select-Object -First 1
}
if (-not $asset) {
    throw "Could not find a Windows x64 Ruffle asset for $($release.tag_name)."
}

Write-Host "Downloading Ruffle $($release.tag_name) ..."
$zipPath = Join-Path $OutputDir $asset.name
New-Item -ItemType Directory -Force -Path $OutputDir | Out-Null

if (-not (Test-Path $zipPath)) {
    Invoke-WebRequest -Uri $asset.browser_download_url -OutFile $zipPath
}

$extractDir = Join-Path $OutputDir "extracted"
if (Test-Path $extractDir) {
    Remove-Item -Recurse -Force $extractDir
}
Expand-Archive -Path $zipPath -DestinationPath $extractDir -Force

$ruffleExe = Get-ChildItem -Path $extractDir -Filter "ruffle.exe" -Recurse | Select-Object -First 1
if (-not $ruffleExe) {
    throw "ruffle.exe not found after extracting $($asset.name)."
}

$result = [ordered]@{
    Tag = $release.tag_name
    Asset = $asset.name
    SourceDir = $ruffleExe.DirectoryName
}

if ($VersionFile) {
    $result | ConvertTo-Json | Set-Content -Path $VersionFile -Encoding UTF8
}

return $result
