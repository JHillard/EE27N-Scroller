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
float lengthC;
Animation timeLapseOne;
Robot mouse;
int SCROLLER_LENGTH; //length in pixels of the mouse path for the scroller.
              // Very large values (>720) can leave empty frame and make it stutter
              // Small values ( ~<200) can cause the animation to reset very quickly and go too fast

//public void init() {
//    /// to make a frame not displayable, you can
//    // use frame.removeNotify()
//    frame.removeNotify(); 
//
//    frame.setUndecorated(true);
//
//    // addNotify, here i am not sure if you have
//    // to add notify again.
//    frame.addNotify();
//    super.init();
//}

void setup(){
  String folderAddress = "/Users/theodiamandis/Documents/EE27N-Scroller/LargeTimeLapse/Images/";
  final int imgCount = 500;
  lengthC = .5;
//  SCROLLER_LENGTH = displayWidth;
  timeLapseOne = new Animation(folderAddress, imgCount);
  size(displayWidth, displayHeight);
  frameRate(24);
//  try {
//    mouse = new Robot();
//  }
//  catch (AWTException e) {
//    println("robot not supported");
//    exit();
//  }
  
  //code for using mousewheel as input:
  // ---------------------------------------
  //MouseWheelListener calls mouseWheelMoved on mouse wheel movement
  addMouseWheelListener(new MouseWheelListener() {
    public void mouseWheelMoved(MouseWheelEvent evt)
    {
      //If not at the start or end of the timelapse, 
      //  increments or decrements frame based on mouse wheel movement
      int newFrame = frame + (int)(lengthC*(int)evt.getWheelRotation());
      if (newFrame >=0 && newFrame < imgCount) {
        frame = newFrame;
      }
    }
  });
  
}

boolean sketchFullScreen() {
  return true;
}

void draw(){
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
//    frame = oldFrame + (int)((float)(lengthC*(mouseX - displayWidth/2))/SCROLLER_LENGTH*imageCount);
//    if(frame < 0) frame = 0;
//    if(frame >= imageCount) frame = imageCount-1;    
    
    image(images[frame], 0, 0);
//    pushMatrix();
//    translate(images[frame].width, 0);
//    scale(-1, 1);
//    image(images[frame], 0, 0);
//    popMatrix();
//    oldFrame = frame;
  }
  
}

