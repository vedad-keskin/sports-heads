@echo off
set ROOT=%~dp0..
set RUFFLE=%ROOT%\tools\ruffle\ruffle.exe
set SWF=%ROOT%\build\patched.swf

if not exist "%SWF%" (
  echo Patched SWF not found. Run scripts\patch-pu-timers.bat first.
  exit /b 1
)

start "" "%RUFFLE%" "%SWF%"
