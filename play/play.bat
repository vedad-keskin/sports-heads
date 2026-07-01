@echo off
set ROOT=%~dp0..
set RUFFLE=%ROOT%\tools\ruffle\ruffle.exe
set SWF=%ROOT%\original\sports_heads_football_championship.swf

if not exist "%RUFFLE%" (
  echo Ruffle not found at %RUFFLE%
  echo Download from https://ruffle.rs/downloads and extract to tools\ruffle\
  exit /b 1
)

if not exist "%SWF%" (
  echo SWF not found at %SWF%
  exit /b 1
)

start "" "%RUFFLE%" "%SWF%"
