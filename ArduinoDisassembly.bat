@set debug=false
@if %debug%==false @echo off
REM ArduinoDisassembly dumps disassembly of the last compiled arduino sketch and opens it in a text editor - ArduinoDissassembly /? for usage and instructions
REM https://github.com/per1234/ArduinoDisassembly

REM handle parameters
if "%~1"=="/?" goto :documentation
if "%~1" neq "" call :processParameter %1
if "%~2" neq "" call :processParameter %2
if "%~3" neq "" call :processParameter %3

REM find the most recent build folder
for /f %%X in ('dir "%TEMP%\arduino_build_*" /a:d /b /o:-d') do set buildFolder=%%X & goto :arduino_buildFolderSearchFinished
:arduino_buildFolderSearchFinished
if "%buildFolder%" neq "" goto :buildFolderFound
REM the build folder name is different previous to Arduino IDE 1.6.12
for /f %%X in ('dir "%TEMP%\build*.tmp" /a:d /b /o:-d') do set buildFolder=%%X & goto :buildFolderFound
if "%buildFolder%" neq "" goto :buildFolderFound
REM a folder was not found matching either of the known build folder names
echo ERROR: Build folder not found
pause
goto :endBatch
:buildFolderFound
set buildPath=%TEMP%\%buildFolder%

REM there is an extra space at the end of the path so trim it off
call :trim buildPath %buildPath%

REM Check if the .elf file is located in the root of the build folder
if exist %buildPath%\*.elf goto :elfLocationFound

REM at some point in the development process of Arduino IDE 1.6.6 they moved the .elf to a sketch subfolder of the build folder but now it seems to be back in the root but now the extension is .ino.elf instead of .cpp.elf
if exist %buildPath%\sketch\*.elf set buildPath=%buildPath%\sketch & goto :elfLocationFound

REM the .elf file was not in either of the known locations
echo ERROR: .elf not found
pause
goto :endBatch

:elfLocationFound

REM get the filename of the .elf
for /f %%X in ('dir "%buildPath%\*.elf" /b /o:-d') do set elfFilename=%%X & goto :elfFileNameFound
:elfFileNameFound

REM determine the sketch name

REM there is an extra space at the end of the filename so trim it off
call :trim elfFilename %elfFilename%

REM trim the .cpp.elf/.ino.elf extension off
set sketchName=%elfFilename:~0,-8%

REM determine the correct Program Files location
set programFilesPath="%PROGRAMFILES%"
REM check if it is 64 bit Windows
if "%PROGRAMFILES(x86)%" neq "" set programFilesPath="%PROGRAMFILES(x86)%"

REM set the path to all the possible locations of avr-objcopy
set previousPath=%PATH%
path %PATH%;%arduinoPath%\hardware\tools\avr\bin\;%programFilesPath%\Arduino\hardware\tools\avr\bin\;%programFilesPath%\arduino-nightly\hardware\tools\avr\bin\;%LOCALAPPDATA%\Arduino15\packages\arduino\tools\avr-gcc\4.9.2-atmel3.5.3-arduino2\bin;%LOCALAPPDATA%\Arduino15\packages\arduino\tools\avr-gcc\4.8.1-arduino5\bin;%LOCALAPPDATA%\Arduino15\packages\arduino\tools\avr-gcc\4.8.1-arduino3\bin;%LOCALAPPDATA%\Arduino15\packages\arduino\tools\avr-gcc\4.8.1-arduino2\bin;%APPDATA%\Arduino15\packages\arduino\tools\avr-gcc\4.9.2-atmel3.5.3-arduino2\bin;%APPDATA%\Arduino15\packages\arduino\tools\avr-gcc\4.8.1-arduino5\bin;%APPDATA%\Arduino15\packages\arduino\tools\avr-gcc\4.8.1-arduino3\bin;%APPDATA%\Arduino15\packages\arduino\tools\avr-gcc\4.8.1-arduino2\bin

if "%sketchFolder%"=="" goto :noSketchFolder
REM find the sketch folder
REM note: the code for finding the sketch folder is not very good because it could match other folders with the same name. It sorts the most recent but that only works within a given folder, the recursive search goes through subfolders in alphabetical order and then it takes the first match
for /f "delims=" %%X in ('dir %sketchFolder%\%sketchName% /a:d /b /o:-d /s') do set sketchPath="%%X" & goto :sketchPathDone
:sketchPathDone
REM trim the extra space from the end of sketchPath
call :trim sketchPath %sketchPath%

REM check to see if there is a sketch in the sketchPath
if not exist %sketchPath%\%sketchName%.ino echo WARNING: sketch not found

REM do the dissassembly dump
avr-objdump -I%sketchPath% -d -S -l -C -j .text "%buildPath%\%elfFilename%" > "%buildPath%\disassembly.txt"
goto :dumpFinished

:noSketchFolder
avr-objdump -d -S -l -C -j .text "%buildPath%\%elfFilename%" > "%buildPath%\disassembly.txt"

:dumpFinished
REM reset the path
path %previousPath%

REM open the text file in the editor
if "%editorPath%"=="" "%buildPath%\disassembly.txt" & goto :endBatch

REM an editor is specified
"%editorPath%" "%buildPath%\disassembly.txt"
goto :endBatch


:processParameter
  set parameter=%~1
  if %parameter:~0,3%==/s: goto :paramSketchFolder
  if %parameter:~0,3%==/S: goto :paramSketchFolder
  if %parameter:~0,3%==/a: goto :paramArduino
  if %parameter:~0,3%==/A: goto :paramArduino
  if %parameter:~0,3%==/e: goto :paramEditor
  if %parameter:~0,3%==/E: goto :paramEditor
goto :eof

:paramSketchFolder
  set sketchFolder=%parameter:~3%
goto :eof

:paramArduino
  set arduinoPath=%parameter:~3%
goto :eof

:paramEditor
  set editorPath=%parameter:~3%
goto :eof

REM trims whitespace - does not work with strings that contains spaces but arduino doesn't allow spaces in filenames so it's ok
:trim
  SetLocal EnableDelayedExpansion
  set Params=%*
  for /f "tokens=1*" %%a in ("!Params!") do EndLocal & set %1=%%b
goto :eof

REM documentation is displayed via the /? switch or by running the batch file without parameters
:documentation
echo(
echo Dumps disassembly of the last compiled Arduino sketch and opens it in a
echo text editor. Save the sketch and compile before running this batch file.
echo(
echo ArduinoDisassembly [/S:"sketchFolder"] [/A:"arduinoPath"] [/E:"textEditor"]
echo(
echo   /S:sketchFolder	(optional)Folder where your sketch folder is located.
echo				Usually this will be the sketchbook folder configured
echo				in your Arduino IDE preferences. Only required for
echo				Arduino IDE versions 1.0.2 - 1.6.5r5.
echo(
echo   /E:textEditor		(optional)Path to the text editor you want to open
echo				the dissassembly output in. If an editor is not
echo				specified then the default program you have
echo				associated with .txt files will be used.
echo(
echo   /A:arduinoPath	(optional)Path to the folder where Arduino IDE is
echo				installed. If this is not specified then the default
echo				install folder will be used.
echo(
goto :endBatch

:endBatch
if %debug%==true pause
exit/b
