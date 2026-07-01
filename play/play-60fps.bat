@echo off
set ROOT=%~dp0..
set RUFFLE=%ROOT%\tools\ruffle\ruffle.exe
set SWF=%ROOT%\build\patched_60fps.swf

if not exist "%SWF%" (
  echo 60fps patched SWF not found at %SWF%
  exit /b 1
)

start "" "%RUFFLE%" "%SWF%"
