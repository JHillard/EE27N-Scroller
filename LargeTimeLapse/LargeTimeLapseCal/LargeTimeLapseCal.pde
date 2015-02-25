/*Sketch: LargeTimeLapse
 * Modified: Feb 2, 2015
 * Implements a timelapse with mouse wheel input
 * IMPORTANT RUN INFORMATION: folderAddress (file tree) must be
      designated fully instead of relatively
 */

import java.awt.event.*;
import java.awt.Robot;
import java.awt.*;

//Global Variables
int frame;
boolean cal;
float lengthC;
Animation timeLapseOne;
Robot mouse;
int dWheel;
final int imgCount = 500;
int time = millis();
int scrollerLength; //length in pixels of the mouse path for the scroller.
              // Very large values (>720) can leave empty frame and make it stutter
              // Small values ( ~<200) can cause the animation to reset very quickly and go too fast



void setup(){
  String folderAddress = "/Users/theodiamandis/Documents/EE27N-Scroller/LargeTimeLapse/Images/";
  dWheel = 0;
  lengthC = .33;
  scrollerLength = displayHeight;
  cal = false;
  frame = 0;

  //code for using mousewheel as input:
  // ---------------------------------------
  //MouseWheelListener calls mouseWheelMoved on mouse wheel movement
  addMouseWheelListener(new MouseWheelListener() {
    public void mouseWheelMoved(MouseWheelEvent evt)
    {
      //If not at the start or end of the timelapse, 
      //  increments or decrements frame based on mouse wheel movement
      int newFrame;
      if (cal) {
        newFrame = frame + (int)(evt.getWheelRotation());

      if (newFrame >=0 && newFrame < imgCount) {
        frame = newFrame;
      }
    }
  });
  
  size(displayWidth, displayHeight);
  frameRate(24);
  
  timeLapseOne = new Animation(folderAddress, imgCount);

//  try {
//    mouse = new Robot();
//  }
//  catch (AWTException e) {
//    println("robot not supported");
//    exit();
//  }

}

boolean sketchFullScreen() {
  return true;
}

void draw(){
  if (!cal) calibrate();
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
    frame = 0;
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
    //Uses only every 4th image, so frame is reduced to nearest mutliple of 4
    // ---------------------------------------
//    frame = oldFrame + (int)((float)(lengthC*(mouseY - displayHeight/2))/scrollerLength*imageCount);
//    if(frame < 0) frame = 0;
//    if(frame >= imageCount) frame = imageCount-1;    
    
//    image(images[frame], displayWidth/2, displayHeight/2);
    pushMatrix();
    translate(images[frame].width, 0);
    scale(-1, 1);
    image(images[frame], 0, 0);
    popMatrix();
    oldFrame = frame;
  }
  
}

