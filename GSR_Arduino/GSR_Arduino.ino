/*
  Chris Smith -- Boston Children's Hospital for Jason Kahn

  This is the program to run on the arduino for use with the GSR
  Processing sketch. The signal from your GSR circuit should be
  sent into pin A0. This sketch reports its data to a serial device
  when it receives an 'a'

*/


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
      sendToProcessing('G', signal);
    }
  }
}

void sendToProcessing(char c, int val){
  Serial.print(c);
  Serial.println(val);
}
