// GSR signal
int signalPin = A0;

void setup(){
  Serial.begin(9600); 
  pinMode(signalPin, INPUT);
}

void loop(){
  // read values
  int signal = analogRead(signalPin);
  if (Serial.available() > 0) {
    // check if data was requested
    byte inbyte=Serial.read();
    if(inbyte=='a'){
      sendToProcessing('S', signal);
    }
  }
}

void sendToProcessing(char c, int val){
  Serial.print(c);
  Serial.println(val);
}
