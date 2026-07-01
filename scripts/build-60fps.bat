@echo off
setlocal EnableExtensions
set ROOT=%~dp0..
set JAVA="C:\Program Files\Eclipse Adoptium\jdk-17.0.19.10-hotspot\bin\java.exe"
set FFDEC=%ROOT%\tools\ffdec\ffdec.jar
set IN=%ROOT%\original\sports_heads_football_championship.swf
set OUT=%ROOT%\build\60fps_patch1.swf
set SCRIPTS=%ROOT%\decompiled\scripts

if not exist "%IN%" (
  echo Original SWF not found: %IN%
  echo Download from https://archive.org/download/sports_heads_football_championship_flash
  exit /b 1
)

if not exist "%SCRIPTS%\Utils.as" (
  echo Missing Utils.as in %SCRIPTS%
  exit /b 1
)

if not exist "%ROOT%\build" mkdir "%ROOT%\build"

set WORK=%ROOT%\build\_60fps_work.swf
copy /Y "%IN%" "%WORK%" >nul
if errorlevel 1 (
  echo Failed to copy input SWF.
  exit /b 1
)

echo Building 60fps_patch1.swf ...
echo.

call :replace Utils "%SCRIPTS%\Utils.as" || exit /b 1
call :replace TimeFunction "%SCRIPTS%\TimeFunction.as" || exit /b 1
call :replace Bomb "%SCRIPTS%\Bomb.as" || exit /b 1
call :replace Trail "%SCRIPTS%\Trail.as" || exit /b 1
call :replace Dust "%SCRIPTS%\Dust.as" || exit /b 1
call :replace SPL_dist1_fla.PUHandler_110 "%SCRIPTS%\SPL_dist1_fla\PUHandler_110.as" || exit /b 1
call :replace SPL_dist1_fla.MainTimeline "%SCRIPTS%\SPL_dist1_fla\MainTimeline.as" || exit /b 1
call :replace SPL_dist1_fla.ChoosePlayer2P_75 "%SCRIPTS%\SPL_dist1_fla\ChoosePlayer2P_75.as" || exit /b 1
call :replace SPL_dist1_fla.score_mc_115 "%SCRIPTS%\SPL_dist1_fla\score_mc_115.as" || exit /b 1
call :replace SPL_dist1_fla.Flasher_131 "%SCRIPTS%\SPL_dist1_fla\Flasher_131.as" || exit /b 1
call :replace SPL_dist1_fla.AchAward_17 "%SCRIPTS%\SPL_dist1_fla\AchAward_17.as" || exit /b 1

echo Setting SWF frame rate to 60...
%JAVA% -jar "%FFDEC%" -header -set framerate 60 "%WORK%" "%OUT%"
if errorlevel 1 (
  echo Failed to set frame rate.
  exit /b 1
)

del "%WORK%" >nul 2>&1
echo.
echo Done: %OUT%
exit /b 0

:replace
echo Replacing %~1 ...
%JAVA% -jar "%FFDEC%" -replace "%WORK%" "%WORK%" %~1 "%~2"
if errorlevel 1 (
  echo Replace failed for %~1
  exit /b 1
)
exit /b 0
