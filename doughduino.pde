/*
 * Copyright (C) 2011  Josh Kropf <josh@slashdev.ca>
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License along
 * with this program; if not, write to the Free Software Foundation, Inc.,
 * 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
 */

// http://www.pjrc.com/teensy/td_libs_OneWire.html
// http://www.pjrc.com/teensy/arduino_libraries/OneWire.zip
#include <OneWire.h>

// http://www.milesburton.com/?title=Dallas_Temperature_Control_Library
// http://download.milesburton.com/Arduino/MaximTemperature/DallasTemperature_371Beta.zip
#include <DallasTemperature.h>

// http://git.slashdev.ca/arduino-lcd
#include <Lcd.h>

#define RELAY_PIN 4
#define SENSOR_PIN 5
#define LED_PIN 13

#define DEBOUNCE_MS 200

OneWire oneWire(SENSOR_PIN);

DallasTemperature sensor(&oneWire);
DeviceAddress sensorAddr;

Lcd lcd = Lcd(16, FUNCTION_4BIT | FUNCTION_2LINE);

int relayState = 0;
int currentTemp;

volatile int targetTemp = 76;
volatile bool redraw = false;

bool errorFlag = false;


void setup()
{
  lcd.set_ctrl_pins(CTRLPINS(6,7,8));
  lcd.set_data_pins(_4PINS(12,11,10,9));

  lcd.setup();

  pinMode(RELAY_PIN, OUTPUT);
  pinMode(LED_PIN, OUTPUT);

  sensor.begin();

  if (!sensor.getAddress(sensorAddr, 0)) {
    lcd.clear();
    lcd.print("plugin DS1820");
    errorFlag = true;
  } else {
    sensor.setResolution(sensorAddr, 9);

    // turn on status LED to indicate OK
    digitalWrite(LED_PIN, HIGH);
  }

  attachInterrupt(0, tempUp, FALLING);
  attachInterrupt(1, tempDown, FALLING);
}

void loop()
{
  if (!errorFlag) {
    service();
  }
}

void service()
{
  sensor.requestTemperatures();

  int temp = (int)sensor.getTempF(sensorAddr);
  if (temp != currentTemp) {
    currentTemp = temp;
    redraw = true;
  }

  if (currentTemp > targetTemp && relayState != 1) {
    digitalWrite(RELAY_PIN, HIGH);
    digitalWrite(LED_PIN, LOW);
    relayState = 1;
  } else if (temp < targetTemp && relayState != 0) {
    digitalWrite(RELAY_PIN, LOW);
    digitalWrite(LED_PIN, HIGH);
    relayState = 0;
  }

  if (redraw) {
    lcd.clear();

    lcd.move_to(1, 1);
    lcd.print("Temp T:"); lcd.print(targetTemp);
    lcd.print(", C:"); lcd.print(currentTemp);

    lcd.move_to(1, 2);
    lcd.print("Lamp is: ");
    lcd.print((char*)(relayState? "Off" : "On"));

    redraw = false;
  }
}

void tempUp()
{
  static unsigned long last_interrupt_time = 0;
  unsigned long interrupt_time = millis();
  if (interrupt_time - last_interrupt_time > DEBOUNCE_MS) {
    targetTemp ++;
    redraw = true;
  }
  last_interrupt_time = interrupt_time;
}

void tempDown()
{
  static unsigned long last_interrupt_time = 0;
  unsigned long interrupt_time = millis();
  if (interrupt_time - last_interrupt_time > DEBOUNCE_MS) {
    targetTemp --;
    redraw = true;
  }
  last_interrupt_time = interrupt_time;
}

