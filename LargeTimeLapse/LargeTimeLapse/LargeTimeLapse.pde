/*Sketch: LargeTimeLapse
 * Modified: Feb 2, 2015 - Theo Diamandis
 * Implements a timelapse with mouse wheel input
 * IMPORTANT RUN INFORMATION: folderAddress (file tree) must be
      designated fully instead of relatively
 */

import java.awt.event.*;

//Global Variables
int frame;
Animation timeLapseOne;
int SCROLLER_LENGTH; //length in pixels of the mouse path for the scroller.
              // Very large values (>720) can leave empty frame and make it stutter
              // Small values ( ~<200) can cause the animation to reset very quickly and go too fast

void setup(){
  String folderAddress = "/Users/theodiamandis/Documents/EE27N-Scroller/LargeTimeLapse/Images/";
  int imgCount = 1444;
  SCROLLER_LENGTH = displayHeight;
  timeLapseOne = new Animation(folderAddress, imgCount);
  size(displayWidth, displayHeight);
  frameRate(24);
  
  //code for using mousewheel as input:
  // ---------------------------------------
  //MouseWheelListener calls mouseWheelMoved on mouse wheel movement
//  addMouseWheelListener(new MouseWheelListener() {
//    public void mouseWheelMoved(MouseWheelEvent evt)
//    {
//      //If not at the start or end of the timelapse, 
//      //  increments or decrements frame based on mouse wheel movement
//      if (frame + evt.getWheelRotation() >=0 && frame + evt.getWheelRotation() < imgCount) {
//        frame += evt.getWheelRotation() - evt.getWheelRotation() % 4;
//      }
//    }
//  });
  
}

boolean sketchFullScreen() {
  return true;
}

void draw(){
 timeLapseOne.display(0, 0);
 noCursor();
}

/*class: Animation
 * implements necessary methods to view a timelapse
 */
class Animation {
  PImage[] images;
  int imageCount;
  int currentMouseY = 0;

  /*method: constructor
   * Preconditions: folderAddress is full file tree in which images are stored
   *                count is the number of images
   * Preloads all images in timelapse
   */
  Animation(String folderAddress, int count) {
    frame = 0;
    imageCount = count;
    images = new PImage[imageCount];
    String imagePrefix = "OpenfootageNET_00153_Clouds_PAL.";
    
    //Preloads each image
    for (int i = 0; i < imageCount; i+=4) {
      // Use nf() to number format 'i' into four digits
      String filename = folderAddress + imagePrefix + nf(i+1, 4) + ".jpg";
      images[i] = loadImage(filename);
      images[i].resize(displayWidth, displayHeight);
    }
  }

  /*method: display(int xpos, int ypos)
   * displays the current image, given by frame, at xpos, ypos
   */
  void display(int xpos, int ypos) {    
    //Code for using ypos of mouse as input:
    //Uses only every 4th image, so frame is reduced to nearest mutliple of 4
    // ---------------------------------------
    frame = (int)((float)mouseY/SCROLLER_LENGTH*imageCount %imageCount);
    frame = frame - frame%4;

    image(images[frame], xpos, ypos);
  }
  
}

