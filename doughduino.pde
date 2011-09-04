#include <OneWire.h>
#include <DallasTemperature.h>
#include <Lcd.h>

#define RELAY_PIN 4
#define SENSOR_PIN 5
#define LED_PIN 13

OneWire oneWire(SENSOR_PIN);
DallasTemperature sensor(&oneWire);

Lcd lcd = Lcd(16, FUNCTION_4BIT | FUNCTION_2LINE);

int relayState = 0;
volatile int targetTemp = 76;

void setup()
{
  lcd.set_ctrl_pins(CTRLPINS(6,7,8));
  lcd.set_data_pins(_4PINS(12,11,10,9));

  lcd.setup();

  sensor.begin();

  pinMode(RELAY_PIN, OUTPUT);
  pinMode(LED_PIN, OUTPUT);

  digitalWrite(LED_PIN, HIGH);

  attachInterrupt(0, temp_up, FALLING);
  attachInterrupt(1, temp_down, FALLING);
}

void loop()
{
  sensor.requestTemperatures();

  lcd.clear();

  int temp = (int)sensor.getTempFByIndex(0);
  lcd.move_to(1, 1);
  lcd.print("Temp T:"); lcd.print(targetTemp);
  lcd.print(", C:"); lcd.print(temp);

  lcd.move_to(1, 2);
  lcd.print("Lamp is: ");
  lcd.print((char*)(relayState? "Off" : "On"));

  if (temp > targetTemp && relayState != 1) {
    digitalWrite(RELAY_PIN, HIGH);
    digitalWrite(LED_PIN, LOW);
    relayState = 1;
  } else if (temp < targetTemp && relayState != 0) {
    digitalWrite(RELAY_PIN, LOW);
    digitalWrite(LED_PIN, HIGH);
    relayState = 0;
  }
}

void temp_up()
{
  targetTemp++;
}

void temp_down()
{
  targetTemp--;
}
