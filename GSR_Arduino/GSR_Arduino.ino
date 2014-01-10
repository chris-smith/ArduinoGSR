int signalPin = A0;

void setup(){
  Serial.begin(9600); 
  pinMode(signalPin, INPUT);
}

void loop(){
  int signal = analogRead(signalPin);
  if (Serial.available() > 0) {
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
