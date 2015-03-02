/*Sketch: ScrollerFinal
 * Modified: Feb 25, 2015
 * Implements a image scroller with mouse wheel input
 */

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
/*Jake EDIT: allows for single screen testing */
final int SCREEN_WIDTH = 1920; //These refer to the 2 screens used for physical scroller
final int SCREEN_HEIGHT = 1080;
int uiMode;
ArrayList<ImageSet> imageSets;
int time;
Movie credits;
//vvv  All initialization vars for Initial menu  vvv
final int selectTime = 5000; //time user must hover over image card
final int idleTime = 300;
final int cardSize = 400;
final int cardSpacing = 400;
int cardSelection = -1;
boolean setup = false;
boolean setSelected = false; 
boolean firstMoved = false;
PImage menuImg;
String menuImgName = "MenuBackground-01.png";
PImage[] menuCard;
int distance;
PImage calImage;
String calImageName = "calibrationScreen.png";


//Overrides default frame settings to allow the frame to
//  stretch across two screens.
public void init() {
  frame.removeNotify(); 
  frame.setUndecorated(true); //Takes top bar off frame for fullscreen effect
  frame.addNotify();
  super.init();
 
}

void setup() {
  //Image set setup
  imageSets = new ArrayList<ImageSet>();  
  imageSets.add(new ImageSet("IM-0001-", "jpg", 696));
  imageSets.add(new ImageSet("palwide", "jpg", 539));
  credits = new Movie(this, "credits.mp4");
  
  //menu setup
  menuCard = new PImage[imageSets.size()]; //creates array of images to display for image sets
  menuImg = loadImage(menuImgName);
  menuImg.resize(SCREEN_WIDTH, 0);
  for (int i = 0; i < menuCard.length; i++) {
    menuCard[i] = imageSets.get(i).getMenuCard();
  }
  
  //Starts UI At calibration screen
  uiMode = -1;
  calImage = loadImage(calImageName);
  
  //stretches frame across the second and third monitor
  size(SCREEN_WIDTH*2, SCREEN_HEIGHT);
  frameRate(24);
  background(0);

  //Creates mouse robot that provides methods to prevents user from moving mouse offscreen
   try {
      mouse = new Robot();
   } catch (AWTException e) {
      println("robot not supported");
      exit();
  }
}

/*method: mouseWheel(MouseEvent event)
 * Called whenever the mouse wheel moves
 *   and changes the currFrame accordingly
 */
void mouseWheel(MouseEvent event) {
  
  //Linear map from position on physical slider to frame number
  position += event.getAmount();
  time = millis();

  if(uiMode == 0){
    firstMoved =true;
  }  
  if(uiMode == 2){
    int newFrame = (int)(position * lengthConst);
    if (newFrame >=0 && newFrame < scroller.getImageCount()) { //checks bounds
      currFrame = newFrame;
      time = millis(); //resets time if moved
    }
  }
}

/*method: moveEvent(Movie m)
 * Allows movie to be played
 */
void movieEvent(Movie m) {
    m.read();
}

/*method: calibrateSliderDistance
 * Sets lengthConst to appropriate value for linear map from the slider position to currFrame
 * Only called during calibration section of draw
 */
void calibrateSliderDistance() {
  int distance;
  int waitC = 3000;
  
  //displays background
  frame.setLocation(displayWidth, 0);
  image(calImage, 0, 0);
  image(calImage, SCREEN_WIDTH, 0);
  
  if ((millis()-time > waitC) && (abs(position) > 1)){
    //Once calibrated, sets distance and switches to menu uiMode
    distance = abs(position);
    uiMode = 0;
  } else {
    //Counts down until calibration confirmation
    int currTime = (int)(waitC - millis() + time )/100;
    if (currTime >= 0) {
      textSize(70);
      text (currTime, SCREEN_WIDTH*5/8, SCREEN_HEIGHT*3/4);
      text (currTime, SCREEN_WIDTH*13/8, SCREEN_HEIGHT*3/4);
    }
  }
}

/*method: menu
 * Draws and updates menu
 * Only called during menu section of draw
 */
void menu(){
  int menuSensitivity = 4;
  int radius = 1000;
  
  //background
  frame.setLocation(displayWidth, 0);
  image(menuImg, 0, 0);
  image(menuImg, SCREEN_WIDTH + 0, 0);
  
  //Holds y positions of cards
  int[] cardY = new int[menuCard.length];
  cardY[0] = position*menuSensitivity - 150;
  for (int i = 1; i < cardY.length; i++) {
    cardY[i] = cardY[i-1] + cardSpacing;
  }
  
  //Updates card placement
  for (int i = 0; i < cardY.length; i++) {
    image(menuCard[i], SCREEN_WIDTH*2/3 + menuCard[0].width/2 + radius - (int)sqrt(radius*radius - cardY[i]*cardY[i]), SCREEN_HEIGHT/2 + cardY[i] - menuCard[i].height/2); 
    image(menuCard[i], SCREEN_WIDTH*5/3 + menuCard[0].width/2 + radius - (int)sqrt(radius*radius - cardY[i]*cardY[i]), SCREEN_HEIGHT/2 + cardY[i] - menuCard[i].height/2); 
  }
  
  //Selects card
  setSelection(menuSensitivity, cardY); 
  
  //Clears the current image from the cache to avoid a memory leak
  //Processing loads a PImage into the cache each time it is called, so not clearing
  //  would inevitably cause the user to run out of memory upon continued use.
  g.removeCache(menuImg);
  g.removeCache(menuCard[0]);
  g.removeCache(menuCard[1]);
  
}

/*method: setSelection
 * Handles choosing of menu
 * Helper for menu method
 */
void setSelection(int menuSensitivity, int[] cardY){ 
  //Does not start selection unless moved and user has spent sufficient time on their choice
  int cardChoice = -1;
  if(firstMoved && millis()-time >= idleTime){
    //Selects card i if sufficiently on selector area
    for (int i = 0; i < menuCard.length; i++) {
      if (cardY[i] <= menuCard[i].height*3/5) {
       cardChoice = i;
      } 
    }
    
    //If selection has been made:
    if(cardChoice != -1){
      textSize(100); 
      fill(0, 102, 153);
      textAlign(CENTER, CENTER);
      
      //Tells user how much time until selection is confirmed
      int currTime = (int)(selectTime - millis()+ time )/100;
      if(currTime > 0) {
        text((int)currTime, SCREEN_WIDTH/2, SCREEN_HEIGHT/2 + 50); 
        text((int)currTime, SCREEN_WIDTH*3/2, SCREEN_HEIGHT/2 + 50); 
      }  
    }
    
    //If selection has been confirmed:
    if(millis()- time >= selectTime) {
      //Switches uiMode to image initialization
      cardSelection = cardChoice;
      uiMode = 1;
      
      //Displays message to user
      textSize(50); 
      fill(0, 102, 153);
      textAlign(LEFT, CENTER);
      text("Please move slider back to start while images Render...", 100, SCREEN_HEIGHT/2 + 50);
      text("Please move slider back to start while images Render...", SCREEN_WIDTH + 100, SCREEN_HEIGHT/2 + 50);    
    }  
  }  
}

/*method imgSetInitialization
 * Creates scroller object
 */
void imgSetInitialization(){
  ImageSet imgs = imageSets.get(cardSelection);
        scroller = new Scroller(imgs.getPrefix(), imgs.getExtension(), 
                                imgs.getImageCount(), SCREEN_WIDTH, SCREEN_HEIGHT);
   lengthConst = (double)(scroller.getImageCount() - 1)/distance;
   uiMode = 2;     
}

/*method scrollerMain
 * Displays the imageSet using the scroller object
 */
void scrollerMain(){
  //black background
  noTint();
  background(0);
  
  //Puts frame on the second monitor
  //Displays across 2nd and 3rd monitors
  //NOTE: Assumes 2nd and 3rd monitors are to the RIGHT of the primary one 
  frame.setLocation(displayWidth, 0);
  scroller.display();
}


void draw() {
  switch(uiMode){
    case -1:
       calibrateSliderDistance();
       break;
    case 0:
       menu();
       break;
    case 1:
       imgSetInitialization();
       break;
    case 2:
       scrollerMain();
       break;
  }

  //hides cursor
  noCursor();
  
  //Prevent the user from moving mouse off applet
  //mouse.mouseMove(displayWidth + SCREEN_WIDTH/2, SCREEN_HEIGHT/2);  
}





/*class: Scroller
 * Implements necessary methods to view an ImageSet using the physical slider
 */
class Scroller {
  PImage[] images;
  int imageCount;
  int wait = 60000; //credits appear after 60s of inactivity
  int sWidth;
  int sHeight;
  int xOff;
  int yOff;

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
    boolean firstPic = true;
    int xSize = 0;
    int ySize = 0;
    for(int i = 0; i < imageCount; i++) {
      // Use nf() to number format 'i' into four digits
      String filename =  imagePrefix + nf(i+1, 4) + extension;
      images[i] = loadImage(filename);
      
      //Calbirates appropriate scale factor from the first picture
      if(firstPic) {
        //scales 1st image appropriately 
        calibrateScaling(images[i]);
        
        //uses 1st image's demensions as resize parameters for others
        xSize = images[i].width;
        ySize = images[i].height;
        firstPic = false;
      } else {
        //Called after initial scaling calibration
        images[i].resize(xSize, ySize);
      }  
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
      tint(255, 50);
      image(credits, 0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
      image(credits, SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
      g.removeCache(credits);
    } else {
      credits.pause();
    }    
    
    //Displays image and its mirror image on screens 2 and 3 respectively
    image(images[currFrame], xOff, yOff);
    scale(-1, 1);
    image(images[currFrame], -2*SCREEN_WIDTH + xOff, yOff);
    
    //Clears the current image from the cache to avoid a memory leak
    //Processing loads a PImage into the cache each time it is called, so not clearing
    //  would inevitably cause the user to run out of memory upon continued use.
    g.removeCache(images[currFrame]);
    

  }
  
  /*method: getImageCount()
   * returns the number of images in the used image set
   */
  int getImageCount() {
    return imageCount;
  }
  
  /*method: calibrateScaling
   * Appropriately scales and centers img according to the dimensions of sWidth and sHeight
   */
  private void calibrateScaling(PImage img) {
    int xSize = 0;
    int ySize = 0;
    if (img.width == sWidth && img.height == sHeight) {
      //Already fits screen; no need to resize or center
      xOff = 0;
      yOff = 0;
    } else if((double)img.width/img.height >= (double)sWidth/sHeight) {
      //if the image width to height ratio is greater than the screen's
      // width is scaled to fill screen and the height is scaled proportionally
      xSize = sWidth;
      ySize = 0;
      img.resize(xSize, ySize);
      
      //centers the image vertically
      yOff = (sHeight - img.height)/2;
      xOff = 0;
    } else {
      //otherwise, scales height to fill and width proportionally
      xSize = 0;
      ySize = sHeight;
      img.resize(xSize, ySize);
      
      //centers image horizontally
      xOff = (sWidth - img.width)/2;
      yOff = 0;
    }
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
  PImage menuCard;
  
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
    
    //menuCard
    menuCard = loadImage(prefix + nf(imageCount/2, 4) + this.extension);
    menuCard.resize(300, 0);
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
  
  PImage getMenuCard() {
    return menuCard;
  }
  
}
    

