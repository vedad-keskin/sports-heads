@echo off
setlocal
set ROOT=%~dp0..
set SWF=%ROOT%\original\sports_heads_football_championship.swf
set FFDEC=%ROOT%\tools\ffdec\ffdec.jar
set DEC=%ROOT%\decompiled

if not exist "%SWF%" (
  echo SWF not found: %SWF%
  exit /b 1
)

echo Exporting all parts to decompiled\ ...
java -jar "%FFDEC%" -export script,image,sound,shape,font,sprite,text,binaryData,frame,button,morphshape "%DEC%" "%SWF%"

echo Done. See decompiled\ARCHITECTURE.md
exit /b 0
