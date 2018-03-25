int inputPin = A0;

void setup() {
  Serial.begin(9600);
}

void loop() {
  int sensorValue = analogRead(inputPin);
  Serial.println(sensorValue);
  delay(200);
}
