/** IMPORTANT RUN INFORMATION:
the file tree needs to be designated fully "C:/tlOne/..etc"
it CANNOT just be in the same sketch folder.Its a weird Processing bug
**/

public static final int SCROLLER_LENGTH = 500; //length in pixels of the mouse path for the scroller.
              // Very large values (>720) can leave empty frame and make it stutter
              // Small values ( ~<200) can cause the animation to reset very quickly and go too fast

Animation timeLapseOne = new Animation("C:/tlOne/GOPR4", 15);
PImage img;                                  

void setup(){
  size(1080, 720);
  frameRate(24); 

}


void draw(){
  
 timeLapseOne.display(0,0);
}

class Animation {
  PImage[] images;
  int imageCount;
  int frame;
  
  Animation(String imagePrefix, int count) {
    imageCount = count;
    images = new PImage[imageCount];

    for (int i = 0; i < imageCount; i++) {
      // Use nf() to number format 'i' into three digits
      String filename = imagePrefix + nf(i, 3) + ".JPG";
      images[i] = loadImage(filename);
      images[i].resize(720, 0 );
    }
  }

  void display(float xpos, float ypos) {
    frame = (int)((float)mouseY/SCROLLER_LENGTH*imageCount %imageCount);
    image(images[frame], xpos, ypos);
  }
  
  int getWidth() {
    return images[0].width;
  }
}






