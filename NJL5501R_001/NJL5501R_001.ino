void setup() {
  Serial.begin(9600);
}

void loop() {
  //int value_red = analogRead(A0);
  //int value_IR = analogRead(A5);

  int value_red = 50;
  int value_IR = 100;
  Serial.print(value_red);
  Serial.print(",");
  Serial.print(value_IR);
  delay(100);
}
