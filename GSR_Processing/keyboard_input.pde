// rudimentary keyboard input -- alphanumeric, enter, delete
void keyPressed(){
  // Keyboard events
  if (!listenToKeyboard) {
    // only listen for individual chars
    lastKey = key;
    return;
  }
  // else
  if (key == ENTER || key == RETURN){
    inputComplete = true;
    //userInput = "ENTER";
  }
  else if (key == ESC){
    // program is going to shutdown, stop any loops
    // by saying input is finished
    inputComplete = true;
    //userInput = "ESC";
  }
  else if (key == DELETE || key == BACKSPACE ){
    userInput = userInput.substring(0, userInput.length()-1 );
    //userInput = "DELETE";
  }
  else if (isAllowed(key))
    userInput += key;
  // else
  //   do nothing
}

boolean isAllowed(char c) {
  // returns true if character is valid -- alphanumeric & '_'
  if (c >= 'a' && c <= 'z' || c >= 'A' && c <= 'Z' || c == '_')
    return true;
  else if (c >= '0' && c <= '9')   
    return true;
  return false;
}

boolean isNum(String str) {
  // returns true if the string is purely numeric
  return (match(str, "[0-9]") != null);
}


