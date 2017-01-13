# ArduinoDisassembly
Windows batch file that displays disassembly of the last compiled [Arduino](http://arduino.cc) sketch with source code.

The disassembly of your compiled sketch shows the assembly that the compiler has created from your code. This can be useful for optimization and debugging. With Arduino IDE versions 1.0.2 up to and including 1.6.5r5 source code from the sketch is not included in the disassembly without pointing avr-objdump to the sketch folder. This batch file automates the process.


#### Installation
- Download the most recent version of ArduinoDisassembly from: https://github.com/per1234/ArduinoDisassembly/archive/master.zip
- Unzip and move the folder to a convenient location.
- You may find it useful to create a shortcut to the batch file with your parameters.


#### Usage
Save the sketch and compile before running ArduinoDisassembly.
If any parameter contains spaces then make sure to enclose it in double quotes.

**`ArduinoDisassembly ["sketchFolder"] [/A:"arduinoPath"] [/E:"textEditor"]`**
- Parameter: **sketchFolder** - (optional)Folder where your sketch folder is located. Usually this will be your sketchbook configured in **File > Preferences > Sketchbook location:**. This is required for the sketch source code to appear in the disassembly when using Arduino IDE versions 1.0.2 up to and including 1.6.5r5.
- Parameter: **/E:textEditor** - (optional)Path to the text editor you want to open the dissassembly output in. If an editor is not specified then the default program you have associated with .txt files will be used.
- Parameter: **/A:arduinoPath**	- (optional)Path to the folder where Arduino IDE is installed. If this is not specified then the default install folder will be used.


#### Related Programs
- WatchdogLog: https://github.com/per1234/WatchdogLog - reports the program address where the most recent watchdog timeout occurred.
- ApplicationMonitor: http://www.megunolink.com/how-to-detect-lockups-using-the-arduino-watchdog - reports the program addresses where a watchdog timeout occurred.


#### Contributing
Pull requests or issue reports are welcome! Please see the [contribution rules](https://github.com/per1234/ArduinoDisassembly/blob/master/CONTRIBUTING.md) for instructions.
