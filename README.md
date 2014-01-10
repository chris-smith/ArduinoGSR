ArduinoGSR
==========

Arduino and Processing Sketches for Visualizing Galvanic Skin Response data

This work is based off of Che-Wei Wang's GSR Reader found here http://cwwang.com/2008/04/13/gsr-reader/

The Processing Sketch is designed for live visualization of GSR data sent over a Serial Connection from an Arduino. Processing will also save the data from each run to a text file. This sketch is meant to be used to validate GSR readings by comparing them to Heart Rate data -- currently much of the infrastructure is in place to do this but is not complete. 

The Arduino Sketch just sets up a Serial Connection and responds with readings when they are requested -- the processing sketch sends out an 'a' to request data.

Getting Started
==============


Arduino

Build a galvanic skin response sensor and send the signal into pin A0 on your Arduino. Then load the Arduino sketch onto the board.

Processing

Open and run the Processing Sketch. You will first be prompted to choose your serial connection. Each serial connection your computer sees should be shown next to a number. Press the number corresponding to your arduino and hit enter. Serial connections with Arduino are not named intuitively, on windows it will be something like "COM3", while on mac it will look like "/dev/tty.usbmodem641" or "/dev/cu.*". After choosing your serial port, you will be asked to name the text file you would like to save the data to. Type out your response and hit enter. If you make a mistake, you should be able to hit delete or backspace. You don't need to write the file extension -- the file will always be saved as a txt file.


The program should now run. By default, it currently plots HR values that increase by 10 every time the graph reaches the end of the window. If you want to plot actual HR data side by side with the GSR values, you'll need to figure out how to adjust some of the code to accept that data. If you can get a HR monitor to talk over serial like the GSR monitor, this should be fairly trivial. Data from runs is saved in the GSR_Processing/data folder.
