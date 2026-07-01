@echo off
setlocal
set ROOT=%~dp0..
set FFDEC=%ROOT%\tools\ffdec\ffdec.jar
set SWF=%ROOT%\original\sports_heads_football_championship.swf
set OUT=%ROOT%\decompiled

if not exist "%FFDEC%" (
  echo FFDec not found at %FFDEC%
  exit /b 1
)

if not exist "%SWF%" (
  echo SWF not found at %SWF%
  exit /b 1
)

echo Exporting %SWF% to %OUT% ...
java -jar "%FFDEC%" -export script,image,sound,shape,font,sprite,text,binaryData,frame "%OUT%" "%SWF%"
exit /b %ERRORLEVEL%
