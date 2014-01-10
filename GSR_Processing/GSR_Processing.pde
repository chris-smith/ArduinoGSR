import processing.serial.*;
Serial gsrPort;    // arduino port
Serial hrPort;
PFont font;
PrintWriter output;

int hPosition = width*2;    // horizontal position on graph
int gsrVal;
int gsrLast;
int hrVal;
int hrLast;

// Approximate GSR minimum and maximum expected readings
// referenced for drawing graph -- change to adjust scale
int gsrMax = 300;  
int gsrMin = 50;

color gsrColor = color(255,0,0);
color hrColor = color(0,0,255);

int graph_height;  //  height of graph window
int graph_offset;  //  y-offset of graph window

String serial_string = "";
boolean serial_input = false;
char lastKey;
String userInput = "";
boolean listenToKeyboard = false;
boolean showPower = false;
boolean inputComplete = false;
boolean initialized = false;
int flash = 0;

String fileName = "";
int lf = 10;      // ASCII linefeed 

void setup() {
  size(900, 600);
  //println(Serial.list());
  
  font = loadFont("Arial-BoldMT-24.vlw");
  
  gsrVal = 0; gsrLast = 0;
  hrVal = 5; hrLast = 0;
  graph_height = (height*3/4); 
  graph_offset = (height - graph_height) / 2;
  
  background(255);
  textAlign(CENTER,CENTER);
  textFont(font);
}

void draw() {
  
  delay(50);
  if (!initialized) {
    _init(); 
  }
  else { 
    listenToKeyboard = false;
    textAlign(CENTER, CENTER);
    //delay(50);
    if (hPosition >= width) {
      // move to left edge. draw over old graph
      hPosition = 1;
      hrVal += 10;
      // cover last drawing
      fill(255,200);
      noStroke();
      rect(0,graph_offset,width,graph_height);
    }
    else {
      hPosition++;
    }
    
    /*fill(255);
    noStroke();
    rect(0,0,100,100);
    fill(0);
    text(gsrVal, 20, 20);
    text(gsrScale(gsrVal), 40, 40);*/
    
    strokeWeight(.5);
    stroke( gsrColor );
    line(hPosition-1, height/2-gsrScale(gsrLast), hPosition, height/2-gsrScale(gsrVal));
    stroke( hrColor );
    line(hPosition-1, height/2-hrLast, hPosition, height/2-hrVal);
    
    writeToFile(gsrVal, hrVal);
    gsrLast = gsrVal;
    hrLast = hrVal;
    
    // ask for more data
    gsrPort.write('a');
    delay(10);
    setVals(serial_string);
    //delay(500);
    drawKey();
  }
  
}

int gsrScale(int val) {
  // scales gsr values for drawing graph
  
  int new_val;
  // reference value to middle of range gsrRange
  new_val =  val - (gsrMax - gsrMin) / 2;
  // scale to graph_height
  new_val = graph_height * (new_val - gsrMin) / gsrMax;
  return constrain(new_val, -graph_height/2, graph_height/2);
}

void _init() {
  // Gets User Input to setup Serial Ports, text files
  
  // Setup GSR Serial Port
  if (gsrPort == null) {
    setup_serial(0);
    return;
  }
  // Setup HR Serial Port, if using
//  if (hrPort == null) {
//    setup_serial(1);
//    return;
//  }

  // Name Text File for Saving Data
  textAlign(CENTER, CENTER);
  listenToKeyboard = true;
  String val;
  fill(255);
  noStroke();
  rect(0,0,width,height);
  fill(0);
  text("Please enter the file name to save this data to", width/2, height/2 - 50);
  if (flash < 30)
      val = "_";
  else
    val = "  ";
  flash++;
  if (flash > 60)
    flash = 0;
  text(userInput + val, width/2, height/2);
  if (inputComplete) {
    initialized = true;
    fileName = userInput;
    int pos = fileName.indexOf('.');
    if (pos > -1)
      fileName = fileName.substring(0,pos);
    fill(255);
    noStroke();
    rect(0,0,width,height);
    output = createWriter("data/"+fileName+".txt"); 
    drawKey();
    inputComplete = false;
  }
}

void stop() {
  // this is run whenever the program exits
  output.flush(); // Writes the remaining data to the file
  output.close(); // Finishes the file
}

void writeToFile(float gsr, float hr) {
 // this writes the gsr and hr data from each loop to a csv file 
 output.println(gsr + ", " + hr);
 output.flush();
}

void drawKey() {
  // draws the legend, file name to screen
   fill(255);
   noStroke();
   rect(0,graph_height + graph_offset,width,height);
   rect(0,0,width, graph_offset);
   textSize(24);
   noStroke();
   float x = 200;
   float y = height*0.95;
   fill(gsrColor);
   //text("____", width/2 - x, y-12);
   text("GSR " + gsrVal, width/2 - x/2-10, y);
   fill(hrColor);
   text("HR " + hrVal, width/2 + x, y);
   fill(0);
   text(fileName + ".txt", width/2, 20);
}
