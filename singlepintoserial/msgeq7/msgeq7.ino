// Example 48.1 - tronixstuff.com/tutorials > chapter 48 - 30 Jan 2013
// MSGEQ7 spectrum analyser shield - basic demonstration
const int strobe = 10; // strobe pins on digital 10
const int res = 9; // reset pins on digital 9
const int channels[7]; // store band values in these arrays
const int input = 2; // channels Pin
void setup()
{
  Serial.begin(115200);
  pinMode(res, OUTPUT); // reset
  pinMode(strobe, OUTPUT); // strobe
  digitalWrite(res, LOW); // reset low
  digitalWrite(strobe, HIGH); //pin 5 is RESET on the shield
}
void readMSGEQ7()
// Function to read 7 band equalizers
{
  digitalWrite(res, HIGH);
  digitalWrite(res, LOW);
  for (int band = 0; band < 7; band++)
  {
    digitalWrite(strobe, LOW); // strobe pin on the shield - kicks the IC up to the next band
    delayMicroseconds(27); // on attend au millieu du 54microS durant lequel le signal est afficher.
    channels[band] = analogRead(2); // store channels band reading
    delayMicroseconds(27);
    digitalWrite(strobe, HIGH);
    delayMicroseconds(18); // on attend que le signal ce rafraichisse
  }
}
void loop()
{
  readMSGEQ7();
  // display values of channels channel on serial monitor
  for (int band = 0; band < 7; band++)
  {
    Serial.print(channels[band]);
    Serial.print(" ");
  }
  Serial.println();

}
