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
/*Jake EDIT: allows for single screen testing */
final int SCREEN_WIDTH = 1366; //These refer to the 2 screens used for physical scroller
final int SCREEN_HEIGHT = 768;
int uiMode = 0;
ArrayList<ImageSet> imageSets;
int time;
Movie credits;
//vvv  All initialization vars for Initial menu  vvv
final int imageSetQuantity = 2;
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


//Overrides default frame settings to allow the frame to
//  stretch across two screens.
public void init() {
  frame.removeNotify(); 
  frame.setUndecorated(true); //Takes top bar off frame for fullscreen effect
  frame.addNotify();
  super.init();
 
}

void setup() {
  //Stores all needed information about each image set
  imageSets = new ArrayList<ImageSet>();  
  imageSets.add(new ImageSet("IM-0001-", "jpg", 696));
  imageSets.add(new ImageSet("palwide", "jpg", 539));
  credits = new Movie(this, "credits.MOV");
  
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
  
menuCard = new PImage[imageSetQuantity]; //creates array of images to display for image sets
menuImg = loadImage(menuImgName);
menuImg.resize(1366, 0);
menuCard[0] = loadImage("IM-0001-0218.jpg");
menuCard[1] = loadImage("palwide0039.jpg");  //needs to be done manually for now. Defines images to use for Set Selection
menuCard[0].resize(300, 0);
menuCard[1].resize(300, 0);
}


//TODO: Mirae
//returns the length of the slider
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
  if(uiMode ==0){
    time = millis(); //resets time if moved
    firstMoved =true;
  }  
  if(uiMode == 2){
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

//TODO: Jake
//returns an integer between 0 and imageSets.size() - 1 that is the index of the image set selected by the user
//_______________________________________MENU UI_______________________________________________________________________
void menu(){
   frame.setLocation(0, 0);
   menuBackground();
   updateCardPlacement(); 
   setSelection();
   
   g.removeCache(menuImg);
   g.removeCache(menuCard[0]);
   g.removeCache(menuCard[1]);
     //Clears the current image from the cache to avoid a memory leak
    //Processing loads a PImage into the cache each time it is called, so not clearing
    //  would inevitably cause the user to run out of memory upon continued use.
}
void menuBackground(){
    //Displays image and its mirror image on screens 2 and 3 respectively
    image(menuImg, 0, 0);
    scale(-1, 1);
    image(menuImg, -2*SCREEN_WIDTH + 0, 0);
}
void updateCardPlacement(){
    int menuSensitivity =17;    
    int radius = 1000;
    int card1Y = position*menuSensitivity -150;
    int card2Y = card1Y + cardSpacing;
    int circleModifier1 = (int) sqrt( radius*radius -card1Y*card1Y);
    int circleModifier2 = (int) sqrt( radius*radius -card2Y*card2Y);
   image( menuCard[0], -SCREEN_WIDTH *2/3 - menuCard[0].width/2 - radius + circleModifier1, SCREEN_HEIGHT/2 + card1Y - menuCard[0].height/2);
   image( menuCard[1], -SCREEN_WIDTH *2/3 - menuCard[0].width/2 - radius + circleModifier2, SCREEN_HEIGHT/2 + card2Y - menuCard[1].height/2);
   
}
void setSelection(){ 
  if(firstMoved){
      int cardChoice = -1;
      int menuSensitivity =17; 
      int card1Y = position*menuSensitivity -150;
      int card2Y = card1Y + cardSpacing;
      println("Y " + card1Y);
      println("Y2 " + card2Y);
    if(millis()-time >= idleTime){  
        if(sqrt(card1Y*card1Y) <= menuCard[0].height*3/5){
            cardChoice = 0;
          }
      if(sqrt(card2Y*card2Y) <= menuCard[1].height*3/5){
          cardChoice = 1;   
          }
      if(cardChoice != -1){
           textSize(100); 
           fill(0, 102, 153);
           textAlign(CENTER, CENTER);
           text((int)(selectTime - millis()+ time )/100, -1260, 360);    
        }
      if(millis()- time >= selectTime) {
        cardSelection = cardChoice;
        uiMode =1;
        textSize(50); 
         fill(0, 102, 153);
         textAlign(CENTER, CENTER);
         text("Please wait while images Render...", -SCREEN_WIDTH/2, 360);    
      }  
    }
  }  
}
//_____________________________________________________END MENU_____________________________________________________________

void imgSetInitialization(){
     
  ImageSet imgs = imageSets.get(cardSelection);
        scroller = new Scroller(imgs.getPrefix(), imgs.getExtension(), 
                                imgs.getImageCount(), SCREEN_WIDTH, SCREEN_HEIGHT);
    
        //Gets calibration distance from user for linear map constant
        lengthConst = (double)(scroller.getImageCount() - 1)/calibrateSliderDistance();
        setup = true; 
   
       
   uiMode = 2;     
}
void scrollerMain(){
        //black background
  noTint();
  background(0);
  
  //Puts frame on the second monitor
  //Displays across 2nd and 3rd monitors
  //NOTE: Assumes 2nd and 3rd monitors are to the RIGHT of the primary one
  
  /*Jake Edit: frame.setLocation(displayWidth, 0); Makes it so I can use just two monitors   */
  frame.setLocation(0, 0);
  scroller.display();
  
  //hides cursor
  noCursor();
  
  //Prevent the user from moving mouse off applet
//  mouse.mouseMove(displayWidth + SCREEN_WIDTH/2, SCREEN_HEIGHT/2);  
}


void draw() {
  
  switch(uiMode){
    
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
    

