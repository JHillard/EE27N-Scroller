/*Sketch: ScrollerFinal
 * Modified: Feb 25, 2015
 * Implements a image scroller with mouse wheel input
 */

//import java.awt.event.*;
import java.awt.Robot;
import java.awt.*;
import javax.swing.*;
import processing.video.*;

//Sketch Instance Variables
int currFrame;
double lengthConst;
int position;
Scroller scroller;
Robot mouse;
final int SCREEN_WIDTH = 1920; //These refer to screens used for physical scroller
final int SCREEN_HEIGHT = 1080;
ArrayList<ImageSet> imageSets;
int time;
Movie credits;



//Overrides default frame settings to allow the frame to
//  stretch across two screens.
public void init() {
  frame.removeNotify(); 
  frame.setUndecorated(true);
  frame.addNotify();
  super.init();
}

void setup() {
  //Stores all needed information about each image set
  imageSets = new ArrayList<ImageSet>();
  imageSets.add(new ImageSet("palwide", "jpg", 539));
  imageSets.add(new ImageSet("IM-0001-", "jpg", 696));
  credits = new Movie(this, "credits.MOV");
  
  //Creates scroller using imageSet picked by user
  ImageSet imgs = imageSets.get(getImageSetNumFromUser());
  scroller = new Scroller(imgs.getPrefix(), imgs.getExtension(), 
                            imgs.getImageCount(), SCREEN_WIDTH, SCREEN_HEIGHT);
  
  //Gets calibration distance from user for linear map constant
  lengthConst = (double)(scroller.getImageCount() - 1)/calibrateSliderDistance();
    
  //stretches frame across the second and third monitor
  size(SCREEN_WIDTH*2, SCREEN_HEIGHT);
  frameRate(24);

  //Creates mouse robot that prevents user from moving mouse offscreen
   try {
      mouse = new Robot();
   } catch (AWTException e) {
      println("robot not supported");
      exit();
  }
  
}

//TODO: Jake
int getImageSetNumFromUser() {
  return 1;
}

//TODO: Mirae
int calibrateSliderDistance() {
  return 1000;
}

/*method: mouseWheel(MouseEvent event)
 * Called whenever the mouse wheel moves
 *   and changes the currFrame accordingly
 */
void mouseWheel(MouseEvent event) {
  
  //Linear map from position on physical slider to frame number
  position += event.getAmount();
  int newFrame = (int)(position * lengthConst);
  
  //checks bounds
  //resets time if moved
  if (newFrame >=0 && newFrame < scroller.getImageCount()) {
    currFrame = newFrame;
    time = millis();
  }
}

/*method: moveEvent(Movie m)
 * Allows movie to be played
 */
void movieEvent(Movie m) {
    m.read();
}

void draw() {
  //Puts frame on the second monitor
  frame.setLocation(displayWidth, 0);
  scroller.display();
  noCursor();

  //Uncomment the following line to prevent the user from messing with the mouse position
//  mouse.mouseMove(displayWidth + SCREEN_WIDTH/2, SCREEN_HEIGHT/2);
}



/*class: Scroller
 * Implements necessary methods to view an ImageSet using the physical slider
 */
class Scroller {
  PImage[] images;
  int imageCount;
  int wait = 60000;
  int sWidth;
  int sHeight;

  /*constructor: Scroller
   * Preconditions: images are stored in the form "prefix####extension"
   *                  extension is in the form ".jpg" or equivalant
   *                sWidth and sHeight refer to the dimensions of the display screens on the slider
   * Preloads imageCount images in the set
   */
  Scroller(String imagePrefix, String extension, int imageCount, int sWidth, int sHeight) {
    images = new PImage[imageCount];
    this.imageCount = imageCount;
    this.sWidth = sWidth;
    this.sHeight = sHeight;
    
    //Preloads each image
    for (int i = 0; i < imageCount; i++) {
      // Use nf() to number format 'i' into four digits
      String filename =  imagePrefix + nf(i+1, 4) + extension;
      images[i] = loadImage(filename);
      images[i].resize(sWidth, sHeight);  
    }
    
  }

  /*method: display
   * Displays the current image and its mirrored image in the frame
   * Plays credits if user has taken no action for wait milliseconds
   * SHOULD WE PASS currFrame?? -- I don't really know the convention for classes within classes
   */
  void display() {    
    
    //If user has not taken action for wait milliseconds, overlays credits on image
    if(millis()- time >= wait) {
      credits.loop();
      image(credits, 0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
      tint(255, 50);
      image(credits, SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
      tint(255, 50);
    } else {
      credits.pause();
    }
    
    //Displays image and its mirror image on screens 2 and 3 respectively
    image(images[currFrame], 0, 0);
    scale(-1, 1);
    image(images[currFrame], -2*SCREEN_WIDTH, 0);
    
    //Clears the current image from the cache to avoid a memory leak
    //Processing loads a PImage into the cache each time it is called, so not clearing
    //  would inevitably cause the user to run out of memory upon continued use.
    g.removeCache(images[currFrame]);
    
  }
  
  /*getImageCount()
   * returns the number of images in the used image set
   */
  int getImageCount() {
    return imageCount;
  }
  
}

/*class: ImageSet
 * Provides a convenient structure for storing information about image sets
 * NOTE: the images for these sets must be in the "data" folder
 */
class ImageSet {
  String prefix;
  String extension;
  int imageCount;
  
  /*constructor: ImageSet
   * sets data from user input
   */
  ImageSet(String prefix, String extension, int imageCount) {
    this.prefix = prefix;
    this.imageCount = imageCount;
    
    //Allows extension to be inputted with or without the period 
    if (extension.charAt(0) != '.') {
      this.extension = "." + extension;
    } else {
      this.extension = extension;
    }
  }
  
  //Getters
  //----------------------------
  String getPrefix() {
    return prefix;
  }
  
  String getExtension() {
    return extension;
  }
  
  int getImageCount() {
    return imageCount; 
  }
  
}
    

