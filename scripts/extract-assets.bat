@echo off
setlocal
set ROOT=%~dp0..
set SWF=%ROOT%\original\sports_heads_football_championship.swf
set FFDEC=%ROOT%\tools\ffdec\ffdec.jar
set DEC=%ROOT%\decompiled
set REMAKE=%ROOT%\remake\assets

if not exist "%SWF%" (
  echo SWF not found: %SWF%
  exit /b 1
)

echo Exporting all parts to decompiled\ ...
java -jar "%FFDEC%" -export script,image,sound,shape,font,sprite,text,binaryData,frame,button,morphshape "%DEC%" "%SWF%"

echo Exporting sounds to remake\assets\audio\ ...
if not exist "%REMAKE%\audio" mkdir "%REMAKE%\audio"
java -jar "%FFDEC%" -export sound "%REMAKE%\audio" "%SWF%"

echo Exporting images to remake\assets\sprites\images\ ...
if not exist "%REMAKE%\sprites\images" mkdir "%REMAKE%\sprites\images"
java -jar "%FFDEC%" -export image "%REMAKE%\sprites\images" "%SWF%"

echo Done. See remake\assets\source\README.md
exit /b 0
