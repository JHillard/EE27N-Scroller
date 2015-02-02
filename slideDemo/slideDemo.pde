/** IMPORTANT RUN INFORMATION:
the file tree needs to be designated fully "C:/tlOne/..etc"
it CANNOT just be in the same sketch folder.Its a weird Processing bug
**/

import java.awt.event.*;
int frame;
public static final int SCROLLER_LENGTH = 500; //length in pixels of the mouse path for the scroller.
              // Very large values (>720) can leave empty frame and make it stutter
              // Small values ( ~<200) can cause the animation to reset very quickly and go too fast

final String folderAddress = "/Users/theodiamandis/Documents/EE27N-Scroller/LargeTimeLapse/Images/";
MouseWheelListener wheel;
int imgCount = 1444;
Animation timeLapseOne = new Animation(folderAddress, imgCount);

void setup(){
  size(720, 486);
  frameRate(24);
  
  addMouseWheelListener(new MouseWheelListener() {
    public void mouseWheelMoved(MouseWheelEvent evt)
    {
      
      if (frame + evt.getWheelRotation() >=0 && frame + evt.getWheelRotation() < imgCount) {
        frame += evt.getWheelRotation();
      }
    }
  });
}

void draw(){

 timeLapseOne.display(0, 0);
}


class Animation {
  PImage[] images;
  int imageCount;

  
  Animation(String folderAddress, int count) {
    frame = 0;
    imageCount = count;
    images = new PImage[imageCount];
    String imagePrefix = "OpenfootageNET_00153_Clouds_PAL.";

    for (int i = 0; i < imageCount; i++) {
      // Use nf() to number format 'i' into three digits
      String filename = folderAddress + imagePrefix + nf(i+1, 4) + ".jpg";
      images[i] = loadImage(filename);
      images[i].resize(720, 0 );
    }
  }

  void display(int xpos, int ypos) {
    
//    frame = (int)((float)mouseY/SCROLLER_LENGTH*imageCount %imageCount);
    image(images[frame], xpos, ypos);
  }
  
  int getWidth() {
    return images[0].width;
  }
}

//void mouseWheel(int






