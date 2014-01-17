/* 
  It would be very easy to adjust this code to accept
  HR data from the same arduino as the GSR. In that case,
  send out a 'g' to get gsr data and an 'h' to get hr data.
  Arduino code would also need slight changes.
*/
  
void serialEvent(Serial thisPort) {
  // Deals with Serial Events
  // Needs some work to deal with simultaneous HR and GSR
  try {
    if (thisPort == gsrPort)
      serial_string = thisPort.readString();
    else if(thisPort == hrPort)
      println(hrPort);
    //setVals( str );
  }
  catch (Exception e) {
    println("Initialization exception");
  }
}

void setCommandValue(String str) {
  // Sets Value for GSR, HR Based on string input
  // Serial command formatted as <char><value>
  // Values are human readable
  //  Example: GSR sends G250
  try {
    // isolate command character
    String cmd_string = str.substring(0,1);
    char cmd = cmd_string.charAt(0);
    // data is remainder of string
    str = str.substring(1);
    switch(cmd) {
      case 'G':
        // GSR signal
        gsrVal = int(str);
        break;
      case 'H':
        // heart rate
        hrVal = int(str);
      default:
        // not a known command
        break;
    }
  }
  catch (Exception e) {
    // Ignore this error. Means empty string
  }
}

void setVals(String input) { 
  // Sets values from serial input
  String[] list = split(input, '\n');
  for (int i = 0; i < list.length; i++) {
    setCommandValue( trim( list[i] ) );
  }   
}

void setup_serial(int which) {  
  // Sets up GSR, HR Serial Ports. Called by void _init()
  // If HR is distinct serial connection, some amount of 
  // uncommenting/adjustment will be required to get HR to work
  
  // which == 0 -> gsr
  // which == 1 -> hr
  textAlign(LEFT, CENTER);
  fill(255);
  noStroke();
  rect(0,0,width,height);
  fill(0);
  
  // get list of serial connections
  //  I currently filter connections
  //  You may find this makes the output less
  //  intuitive due to the numbering...
  String list[] = filterSerialList(Serial.list());
  int len = list.length;
  // display available serial connections
  String name = "GSR";
  if (which == 1) name = "HR";
  String val = "Please Choose a Serial Connection [0-"+(len-1)+"] for " + name + "\n ";
  for( int i = 0; i < len; i++ ) {
    if (list[i] != "") {
      val += "     " + str(i) + ": " + list[i];
      if (i+1 < len)  val += "\n ";
    }
  }
  // flash a cursor
  text(val, width/5, height/2);
  listenToKeyboard = true;
  textAlign(CENTER, CENTER);
  if (flash < 5)
    val = "_";
  else
    val = "  ";
  flash++;
  if (flash > 10)
    flash = 0;
  text(userInput + val, width/2, height - 15);
  int port = -1;
  if (inputComplete)
  {
    // check that user input is purely numeric
    if (isNum(userInput))
      port = int(userInput);
    // if port is within the range of available serial connections
    if (0 <= port && port <= len) {
      // try to setup serial connections
      if (which == 0) {
        try{
          // attempt to set up serial connection
          gsrPort = new Serial(this, Serial.list()[port], 9600);
          gsrPort.clear();
          gsrPort.bufferUntil(lf);
          // Throw out the first reading, in case we started reading 
          // in the middle of a string from the sender.
          String myString = gsrPort.readString();
        }
        catch ( Exception e ) {
          // error setting up new serial connection
          //  -- connection may be busy, etc
        } 
      }
      else if (which == 1) {
        hrPort = new Serial(this, Serial.list()[port], 9600);
        if(hrPort != null)
          println("hr port initialized");
        //hrPort.clear();
        //hrPort.bufferUntil(lf);
        // Throw out the first reading, in case we started reading 
        // in the middle of a string from the sender.
        //String myString = hrPort.readString();
      }
    }
    else{
      //text("Choose a number between 0 and " + (len-1), width/2, height - 20);
    }
    userInput = "";
    inputComplete = false;
  }
}
  
String[] filterSerialList(String[] arr) {
  // filter out any connections that contains
  //  "Bluetooth" in the name
  for (int i = 0; i < arr.length; i++) {
    if ( match(arr[i], "Bluetooth") != null )
      arr[i] = "";
  }  
  return arr;
}


