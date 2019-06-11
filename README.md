# ArduinoDisassembly
Windows batch file that displays disassembly of the last compiled [Arduino](http://arduino.cc) sketch with source code. NOTE: this is only for use with AVR boards (Uno, Mega, Leonardo, etc.).

The disassembly of your compiled sketch shows the assembly that the compiler has created from your code. This can be useful for optimization and debugging. From Arduino IDE versions 1.0.2 up to and including 1.6.5-r5 source code from the sketch is not intermixed in the disassembly unless avr-objdump is pointed to the sketch folder. This batch file automates the process.


#### Installation
- Download the most recent version of ArduinoDisassembly from: https://github.com/per1234/ArduinoDisassembly/archive/master.zip
- Unzip and move to a convenient location.
- You may find it useful to create a shortcut to the batch file with your parameters.


#### Usage
Save the sketch and compile before running ArduinoDisassembly.
If any parameter contains spaces then make sure to enclose it in double quotes.
NOTE: Intermixed source code is not possible with Arduino AVR Boards 1.6.12-1.6.15. This was fixed in newer versions by the [addition of the -g compiler flag](https://github.com/arduino/Arduino/commit/35e45c9fe09279e1d5736032dad2dc892e35b6fe).

**`ArduinoDisassembly ["sketchFolder"] [/A:"arduinoPath"] [/E:"textEditor"]`**
- Parameter: **sketchFolder** - (optional) Folder where your sketch folder is located. Usually this will be your sketchbook configured in **File > Preferences > Sketchbook location:**. This is required for the sketch source code to be intermixed with the disassembly when using Arduino IDE versions 1.0.2 up to and including 1.6.5-r5. This option should not be used with IDE versions outside that range.
- Parameter: **/E:textEditor** - (optional) Path to the text editor you want to open the disassembly output in. If an editor is not specified then the default program you have associated with .txt files will be used.
- Parameter: **/A:arduinoPath** - (optional) Path to the folder where Arduino IDE is installed. This is used to locate avr-objdump. If this is not specified then the batch file will attempt to find avr-objdump in the standard locations.


#### Contributing
Pull requests or issue reports are welcome! Please see the [contribution rules](https://github.com/per1234/ArduinoDisassembly/blob/master/.github/CONTRIBUTING.md) for instructions.
