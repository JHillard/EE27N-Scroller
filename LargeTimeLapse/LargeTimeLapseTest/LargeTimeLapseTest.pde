/*Sketch: LargeTimeLapse
 * Modified: Feb 2, 2015
 * Implements a timelapse with mouse wheel input
 * IMPORTANT RUN INFORMATION: folderAddress (file tree) must be
 designated fully instead of relatively
 */

//import java.awt.event.*;
//import java.awt.Robot;
import java.awt.*;
import javax.swing.*;

//Global Variables
int currImg;
float lengthC;
Animation timeLapseOne;
//Robot mouse;
final int imgCount = 200;


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
  
  
  String folderAddress = "/Users/theodiamandis/Documents/EE27N-Scroller/LargeTimeLapse/Images/";
  lengthC = .5;
  //  SCROLLER_LENGTH = displayWidth;
  timeLapseOne = new Animation(folderAddress, imgCount);
  size(displayWidth*2, displayHeight);
  frameRate(24);
  stroke(0);
}

void mouseWheel(MouseEvent event) {
  int delta = (int)(lengthC*event.getAmount());
  int newFrame = currImg + delta;

  if (newFrame >=0 && newFrame < imgCount) {
    currImg = newFrame;
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

/*class: Animation
 * implements necessary methods to view a timelapse
 */
class Animation {
  PImage[] images;
  int imageCount;
  int oldFrame;

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
    String imagePrefix = "palwide";

    //Preloads each image
    for (int i = 0; i < imageCount; i++) {
      // Use nf() to number format 'i' into four digits
      String filename = folderAddress + imagePrefix + nf(i+6, 4) + ".jpg";
      images[i] = loadImage(filename);
      images[i].resize(displayWidth, displayHeight);
    }
  }

  /*method: display(int xpos, int ypos)
   * displays the current image, given by frame, at xpos, ypos
   */
  void display() {    
    //Code for using ypos of mouse as input:
    //Uses only every 4th image, so frame is redmuced to nearest mutliple of 4
    // ---------------------------------------
    //    frame = oldFrame + (int)((float)(lengthC*(mouseX - displayWidth/2))/SCROLLER_LENGTH*imageCount);
    //    if(frame < 0) frame = 0;
    //    if(frame >= imageCount) frame = imageCount-1;    

    image(images[currImg], 0, 0);
    
//    pushMatrix();
////    translate(images[currImg].width, 0);
    scale(-1, 1);
    image(images[currImg], -2*images[currImg].width, 0);
//    popMatrix();
    
  }
}

