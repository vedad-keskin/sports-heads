@echo off
setlocal
set ROOT=%~dp0..
set FFDEC=%ROOT%\tools\ffdec\ffdec.jar
set IN=%ROOT%\original\sports_heads_football_championship.swf
set OUT=%ROOT%\build\patched.swf
set SCRIPT=%ROOT%\decompiled\scripts\SPL_dist1_fla\PUHandler_110.as

if not exist "%SCRIPT%" (
  echo Script not found: %SCRIPT%
  exit /b 1
)

New-Item -ItemType Directory -Force -Path "%ROOT%\build" | Out-Null
echo Patching PUHandler_110 into %OUT% ...
java -jar "%FFDEC%" -replace "%IN%" "%OUT%" "SPL_dist1_fla.PUHandler_110" "%SCRIPT%"
exit /b %ERRORLEVEL%
