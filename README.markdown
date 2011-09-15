About
-----
Arduino based temperature control device designed for proving bread dough.
See my [blog post](http://www.slashdev.ca/2011/09/15/doughduino/) for details.


Required Libraries
------------------
- [OneWire](http://www.pjrc.com/teensy/td_libs_OneWire.html)
- [DallasTemperature](http://www.milesburton.com/?title=Dallas_Temperature_Control_Library)
- [Lcd](http://git.slashdev.ca/arduino-lcd)


Flashing Arduino Bootloader
---------------------------
The doughduino circuit does not have an ICSP socket. You will need to either
temporarily wire one in, or flash the ATmega8 chip in another circuit. For
example; an Arduino Diecimila or NG (maybe UNO too). Just remove the Arduino
AVR chip and replace with your ATmega8 in need of a bootloader. Then use an
[AVR-ISP](http://www.ladyada.net/make/usbtinyisp/) programmer to burn firmware
(ARDUINO_HOME/hardware/arduino/bootloaders/atmega8/ATmegaBOOT.hex).


Uploading Doughduino Sketch
---------------------------
Doughduino includes a header for uploading sketches using a USB to serial adapter.
I use the [Sparkfun 3.3v FTDI Breakout](http://www.sparkfun.com/products/8772).

1. Download and install required libraries above
2. Open doughduino sketch with Arduino IDE
3. Select *Arduino NG or older /w ATmega8* from boards list in tools menu
4. Connect USB-serial adapter to doughduino and a 5v power source
5. Press reset button on doughduino, and then click *Upload* in Arduino IDE
6. Profit


Reference
---------
- [ATmega8 Arduino Pins](http://www.arduino.cc/en/Hacking/PinMapping)
- [Arduino Bootloader](http://www.arduino.cc/en/Hacking/Bootloader)
- [Standalone Arduino](http://www.arduino.cc/playground/Learning/AtmegaStandalone)
- [Arduino on a Breadboard](http://itp.nyu.edu/physcomp/Tutorials/ArduinoBreadboard)

