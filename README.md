# ArduinoDisassembly
Windows batch file that displays disassembly of the last compiled Arduino sketch with source code.

The disassembly of your compiled sketch shows the assembly that the compiler has created from your code. This can be useful for optimization and debugging. With Arduino IDE 1.0.2 onwards source code from the sketch is not included in the disassembly without pointing avr-objdump to the sketch folder. This batch file automates the process.


#### Installation
- Download - Click the "Download ZIP" button(or "Clone in Desktop" if you have GitHub Desktop installed)
- Unzip and move the folder to a convenient location.
- You may find it useful to create a shortcut to the batch file with your parameters. If the parameter contains spaces then make sure to enclose it in double quotes.


#### Usage
Save the sketch and compile before running ArduinoDisassembly.  

`ArduinoDisassembly "sketchFolder" [/A:"arduinoPath"] [/E:"textEditor"]`
- Parameter: **sketchFolder** - Folder where your sketch folder is located. Usually this will be the sketchbook folder configured in your Arduino IDE preferences.
- Parameter: **/E:textEditor** - (optional)Path to the text editor you want to open the dissassembly output in. If an editor is not specified then the default program you have associated with .txt files will be used.
- Parameter: **/A:arduinoPath**	- (optional)Path to the folder where Arduino IDE is installed. If this is not specified then the default install folder will be used.


#### Related Programs
- WatchdogLog: https://github.com/per1234/WatchdogLog - reports the program address where the most recent watchdog timeout occurred.
- ApplicationMonitor: http://www.megunolink.com/how-to-detect-lockups-using-the-arduino-watchdog - reports the program addresses where a watchdog timeouts occurred.
