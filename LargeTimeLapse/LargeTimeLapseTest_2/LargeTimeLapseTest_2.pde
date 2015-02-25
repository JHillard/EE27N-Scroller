/*Sketch: LargeTimeLapse
 * Modified: Feb 224, 2015
 * Implements a timelapse with mouse wheel input
 * IMPORTANT RUN INFORMATION: folderAddress (file tree) must be
 designated fully instead of relatively
 */

//import java.awt.event.*;
//import java.awt.Robot;
import java.awt.*;
import javax.swing.*;
import processing.video.*;

//Global Variables
int currImg;
float lengthC;
Animation timeLapseOne;
//Robot mouse;
final int imgCount = 690;
int time;
Movie myCredits;

public void init() {
  frame.removeNotify(); 
  frame.setUndecorated(true);
  frame.addNotify();
  super.init();
}

void setup() {
//  GraphicsEnvironment ge = GraphicsEnvironment.getLocalGraphicsEnvironment();
//  GraphicsDevice[] gs = ge.getScreenDevices();
//  frame = new JFrame(gs[1].getDefaultConfiguration());
//  frame.setLocation(0, 0);
  
  
  String folderAddress = "/Users/chris/Documents/EE27N-Scroller/LargeTimeLapse/CTScan2.1/";
  lengthC = .5;
  //  SCROLLER_LENGTH = displayWidth;
  timeLapseOne = new Animation(folderAddress, imgCount);
  size(displayWidth, displayHeight);
  frameRate(24);
  stroke(0);
  myCredits = new Movie(this, "/Users/chris/Pictures/GoProCF/GOPR9972.MP4");
  myCredits.loop();
}

void mouseWheel(MouseEvent event) {
  int delta = (int)(lengthC*event.getAmount());
  int newFrame = currImg + delta;
  
  if (newFrame >=0 && newFrame < imgCount) {
    currImg = newFrame;
    time = millis();
  }
}


boolean sketchFullScreen() {
  return true;
}

void draw() {
  frame.setLocation(0,0);
  timeLapseOne.display();
  // mouse.mouseMove(displayWidth/2, displayHeight/2);
  noCursor();
}

void movieEvent(Movie m) {
    m.read();
  }
  
/*class: Animation
 * implements necessary methods to view a timelapse
 */
class Animation {
  PImage[] images;
  int imageCount;
  int oldFrame;
  PImage screensaver;
  
  /*method: constructor
   * Preconditions: folderAddress is full file tree in which images are stored
   *                count is the number of images
   * Preloads all images in timelapse
   */
  Animation(String folderAddress, int count) {
    currImg = 0;
    imageCount = count;
    oldFrame = 0;
    images = new PImage[imageCount];
    String imagePrefix = "IM-0001-";
    
    
    //Preloads each image
    for (int i = 0; i < imageCount; i++) {
      // Use nf() to number format 'i' into four digits
      String filename = folderAddress + imagePrefix + nf(i+1, 4) + ".jpg";
      images[i] = loadImage(filename);
      images[i].resize(displayWidth, displayHeight);
    }
  }

  /*method: display(int xpos, int ypos)
   * displays the current image, given by frame, at xpos, ypos
   */
  void display() {      
    
    int wait = 10000;
    if(millis()- time >= wait){
      image(myCredits, 0, 0);
      tint(255,127);
      image(images[currImg], 0, 0);
    } else {
    image(images[currImg], 0, 0);
    
//    pushMatrix();
////    translate(images[currImg].width, 0);
 //   scale(-1, 1);
 //   image(images[currImg], -2*images[currImg].width, 0);

//    popMatrix();
    }
    
  }
}

