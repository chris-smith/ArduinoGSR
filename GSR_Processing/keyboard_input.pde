
void keyPressed(){
  // Keyboard events
  if (!listenToKeyboard) {
    // only listen for individual chars
    lastKey = key;
    return;
  }
  if (key == ENTER || key == RETURN){
    inputComplete = true;
    //userInput = "ENTER";
  }
  else if (key == ESC){
    inputComplete = true;
    //userInput = "ESC";
  }
  else if (key == DELETE || key == BACKSPACE ){
    userInput = userInput.substring(0, userInput.length()-1 );
    //userInput = "DELETE";
  }
  else if (isAllowed(key))
    userInput += key;
}

boolean isAllowed(char c) {
  // checks if character is valid -- alphanumeric & '_'
  if (c >= 'a' && c <= 'z' || c >= 'A' && c <= 'Z' || c == '_')
    return true;
  else if (c >= '0' && c <= '9')   
    return true;
  return false;
}

boolean isNum(String str) {
  // checks if the string is purely numeric
  return (match(str, "[0-9]") != null);
}


