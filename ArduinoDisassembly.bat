@echo off
REM ArduinoDisassembly dumps disassembly of the last compiled arduino sketch and opens it in a text editor - ArduinoDissassembly /? for usage and instructions

REM handle parameters

REM no arguments so exit
if "%~1"=="" goto :documentation

REM display documentation
if "%~1"=="/?" goto :documentation

call :PROCESSPARAMETER %1
if "%~2" neq "" call :PROCESSPARAMETER %2
if "%~3" neq "" call :PROCESSPARAMETER %3

if "%sketchFolder%"=="" exit

REM default values
if "%arduinoPath%"=="" goto :defaultArduinoPath
:defaultArduinoPathDone

REM find the most recent build folder
FOR /F %%X IN ('DIR "%TEMP%\build*.tmp" /a:d /B /O:-D') DO set buildPath=%TEMP%\%%X & GOTO :p
:p

REM there is an extra space at the end of the path so trim it off
CALL :TRIM buildPath %buildPath%

REM get the filename of the .elf
FOR /F %%X IN ('DIR "%buildPath%\*.cpp.elf" /B /O:-D') DO set elfFilename=%%X & GOTO :p2 
:p2

REM determine the sketch name
REM there is an extra space at the end of the filename so trim it off
CALL :TRIM elfFilename %elfFilename%

REM trim the .cpp.elf extension off
set sketchName=%elfFilename:~0,-8%

REM find the sketch folder
FOR /F "delims=" %%X IN ('DIR "%sketchFolder%\%sketchName%?" /a:d /B /O:-D /s') DO set sketchPath="%%X" & goto :sketchPathFound
:sketchPathFound

REM do the dissassembly dump
REM set the path to both of the possible locations of avr-objcopy(Arduino IDE 1.6.2 moved the location)
path %arduinoPath%; %arduinoPath%\hardware\tools\avr\bin\;%APPDATA%\Arduino15\packages\arduino\tools\avr-gcc\4.8.1-arduino2\bin
avr-objdump -I%sketchPath% -d -S -j .text "%buildPath%\%elfFilename%" > "%buildPath%\disassembly.txt" & GOTO :p3
:p3

REM open the text file in the editor
REM no editor specified
if "%editorPath%"=="" "%buildPath%\disassembly.txt" & goto :ENDBATCH

REM an editor is specied
"%editorPath%" "%buildPath%\disassembly.txt"
goto :ENDBATCH


:PROCESSPARAMETER
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
:TRIM
SetLocal EnableDelayedExpansion
set Params=%*
for /f "tokens=1*" %%a in ("!Params!") do EndLocal & set %1=%%b
GOTO :eof

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
echo				install folder will be used. This is only needed
echo				for Arduino IDE versions < 1.6.2.
echo(
goto :ENDBATCH

:ENDBATCH
exit/b

REM note: the code for finding the sketch folder is not very good because it could match other folders with the same name or the same name with a character added. It sorts the most recent but that only works within a given folder, the recursive search goes through subfolders in alphabetical order and then it takes the first match