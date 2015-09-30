@echo off
REM ArduinoDisassembly dumps disassembly of the last compiled arduino sketch and opens it in a text editor - ArduinoDissassembly /? for usage and instructions

REM handle parameters

REM no arguments so exit
if "%~1"=="" echo Error: sketch folder must be specified & goto :documentation

REM display documentation
if "%~1"=="/?" goto :documentation

call :processParameter %1
if "%~2" neq "" call :processParameter %2
if "%~3" neq "" call :processParameter %3

if "%sketchFolder%"=="" echo Error: sketch folder must be specified & pause & goto :endBatch

REM default values
if "%arduinoPath%"=="" goto :defaultArduinoPath
:defaultArduinoPathDone

REM find the most recent build folder
for /f %%X in ('dir "%TEMP%\build*.tmp" /a:d /b /o:-d') do set buildPath=%TEMP%\%%X & goto :buildFolderFound
:buildFolderFound

REM there is an extra space at the end of the path so trim it off
call :trim buildPath %buildPath%
if exist %buildPath%\*.elf goto :elfLocationFound

REM At some point in the development process of Arduino IDE 1.6.6 they moved the .elf to a sketch subfolder of the build folder but now it seems to be back in the root but now the extension is .ino.elf instead of .cpp.elf
if exist %buildPath%\sketch\*.elf set buildPath=%buildPath%\sketch & goto :elfLocationFound

echo ERROR: .elf not found
pause
exit

:elfLocationFound
REM get the filename of the .elf
for /f %%X in ('dir "%buildPath%\*.elf" /b /o:-d') do set elfFilename=%%X & goto :elfFileNameDone
:elfFileNameDone

REM determine the sketch name
REM there is an extra space at the end of the filename so trim it off
call :trim elfFilename %elfFilename%

REM trim the .cpp.elf extension off
set sketchName=%elfFilename:~0,-8%

REM find the sketch folder
REM note: the code for finding the sketch folder is not very good because it could match other folders with the same name or the same name with a character added. It sorts the most recent but that only works within a given folder, the recursive search goes through subfolders in alphabetical order and then it takes the first match
for /f "delims=" %%X in ('dir "%sketchFolder%\%sketchName%?" /a:d /b /o:-d /s') do set sketchPath="%%X" & goto :sketchPathDone
:sketchPathDone

REM do the dissassembly dump
REM set the path to both of the possible locations of avr-objcopy(Arduino IDE 1.6.2 moved the location)
path %arduinoPath%;%arduinoPath%\hardware\tools\avr\bin\;%APPDATA%\Arduino15\packages\arduino\tools\avr-gcc\4.8.1-arduino2\bin
avr-objdump -I%sketchPath% -d -S -j .text "%buildPath%\%elfFilename%" > "%buildPath%\disassembly.txt"

REM open the text file in the editor
REM no editor specified
if "%editorPath%"=="" "%buildPath%\disassembly.txt" & goto :endBatch

REM an editor is specied
"%editorPath%" "%buildPath%\disassembly.txt"
goto :endBatch


:processParameter
  set parameter=%~1
  if %parameter:~0,3%==/a: goto :paramArduino
  if %parameter:~0,3%==/A: goto :paramArduino
  if %parameter:~0,3%==/e: goto :paramEditor
  if %parameter:~0,3%==/E: goto :paramEditor

  set sketchFolder=%parameter%
goto :eof

:paramArduino
  set arduinoPath=%parameter:~3%
goto :eof

:paramEditor
  set editorPath=%parameter:~3%
goto :eof

REM determine the correct Program Files location
:defaultArduinoPath
  set programFilesPath="%PROGRAMFILES%"
  REM check if it is 64 bit Windows
  if "%PROGRAMFILES(x86)%" neq "" set programFilesPath="%PROGRAMFILES(x86)%"
  set arduinoPath=%programFilesPath%\Arduino
goto :defaultArduinoPathDone

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
  echo ArduinoDisassembly "sketchFolder" [/A:"arduinoPath"] [/E:"textEditor"]
  echo(
  echo   sketchFolder		Folder where your sketch folder is located. Usually
  echo				this will be the sketchbook folder configured
  echo				in your Arduino IDE preferences.
  echo(
  echo   /E:textEditor		(optional)Path to the text editor you want to open
  echo				the dissassembly output in. If an editor is not
  echo				specified then the default program you have
  echo				associated with .txt files will be used.
  echo(
  echo   /A:arduinoPath	(optional)Path to the folder where Arduino IDE is
  echo				installed. If this is not specified then the default
  echo				install folder will be used. This is only needed for
  echo				Arduino IDE versions older than 1.6.2.
  echo(
  pause
goto :endBatch

:endBatch
  exit/b
