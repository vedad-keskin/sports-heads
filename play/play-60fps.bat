@echo off
set ROOT=%~dp0..
set RUFFLE=%ROOT%\tools\ruffle\ruffle.exe
set SWF=%ROOT%\build\60fps_patch1.swf

if not exist "%RUFFLE%" (
  echo Ruffle not found at %RUFFLE%
  echo Download from https://ruffle.rs/downloads and extract to tools\ruffle\
  exit /b 1
)

if not exist "%SWF%" (
  echo 60fps_patch1.swf not found at %SWF%
  echo Run scripts\build-60fps.bat once to build it.
  exit /b 1
)

start "" "%RUFFLE%" "%SWF%"
