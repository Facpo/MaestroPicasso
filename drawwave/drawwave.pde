import processing.pdf.*;
import processing.serial.*;

Serial myPort;  // The serial port

float x, y;
float prevX=0.0, prevY=0.0;
float numOfWaves = 10;
float angle = 0;
float amplitude=1;
int rows = 1440;
int cols = 7;
float[][] myArray = new float[rows][cols];
boolean recording = false;
boolean recorded = false;
final int lf = 10;    // Linefeed in ASCII
String inString = null;
int sampleIndex = 0;
boolean firstSample = true;

void setup() {

  // Give random value
  /* for (int i =0; i < cols; i++) {
   for (int j = 0; j < rows; j++) {
   myArray[j][i] = random(0, height/16);
   }
   } */
  size(1440, 720);
  background(0);
  stroke(255);
}


void draw()
{
  if (recording) {
    if (firstSample) {
      myPort = new Serial(this, Serial.list()[0], 9600);
      myPort.clear();
      firstSample = false;
      sampleIndex = 0;
    }
    if (myPort.available() > 0) {
      inString = myPort.readStringUntil(lf);
      if (inString.startsWith(">")) {
        recorded = true;
        String[] values = inString.split(" ");
        int i = 0;
        for (String value : values) {
          myArray[sampleIndex][i] = Float.parseFloat(value);
          i++;
        }
        sampleIndex++;
      }
    }
  } else if (recorded) {
    createSVG();
  }
}


void createSVG() {
  //reset recorded state since were using up read values
  recorded = false

  beginRecord(PDF, "filename.pdf");

  for (int i=0; i < 7; i++) {

    translate(0, height/8);

    // Downscalling Frenquency to fit a few cycles into the screen
    float frequence;
    float minRange = 0.8;
    float maxRange = 4;

    switch (i) {
    case 0 : 
      frequence = map(60.0, 0.0, 4000.0, minRange, maxRange);
      break;
    case 1 : 
      frequence = map(120.0, 0.0, 4000.0, minRange, maxRange);
      break;
    case 2 : 
      frequence = map(240, 0.0, 4000.0, minRange, maxRange);
      break;
    case 3 : 
      frequence = map(480, 0.0, 4000.0, minRange, maxRange);
      break;
    case 4 : 
      frequence = map(960, 0.0, 4000.0, minRange, maxRange);
      break;
    case 5 : 
      frequence = map(1920, 0.0, 4000.0, minRange, maxRange);
      break;
    default : 
      frequence = map(3840, 0.0, 4000.0, minRange, maxRange);
    }

    for (int x=0; x < width; x+=1)
    {
      if (x%10 == 0) {
        amplitude = myArray[x][i];
      }
      angle = radians(frequence*x);
      y = amplitude*sin(angle*(numOfWaves/2)+PI);

      //y = map(y, -amplitude, amplitude, -height/16, height/16);

      line(prevX, prevY, x, y);

      prevX = x;
      prevY = y;
    }

    prevX = prevY = 0.0;
  }

  endRecord();
}

void keyPressed() {
  if (key == 'r') {
    if (recording == false) {
      recording = true;
    } else {
      //Close port in case this isn't first recording session
      myPort.stop();
      recording = false;
      firstSample = true;
    }
  }
}