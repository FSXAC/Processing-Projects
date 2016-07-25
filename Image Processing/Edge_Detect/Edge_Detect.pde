// Image spotlight

// load the image
PImage img;

// setup
void setup() {
  img = loadImage("/../boat_resized.jpg");
  size(1000, 750);
}

// draw
void draw() {
  int centerPixel;
  int leftPixel = 0, rightPixel = 0;
  int topPixel = 0, topLeftPixel = 0, topRightPixel = 0;
  int btmPixel = 0, btmLeftPixel = 0, btmRightPixel = 0;
  
  loadPixels();
  
  // loop through all pixels
  for (int x = 0; x < img.width; x++) {
    for (int y = 0; y < img.height; y++) {
      // get index from loop
      centerPixel = y * img.width + x;
      
      // left
      if (x != 0) {
        leftPixel = y * img.width + x - 1;
        if (y != 0) {
          topLeftPixel = (y - 1) * img.width + x - 1;
        }
        if (y != height) {
          btmLeftPixel = (y + 1) * img.width + x - 1;
        }
      }
      
      // right
      if (x != width) {
        rightPixel = y * img.width + x + 1;
        if (y != 0) {
          topRightPixel = (y - 1) * img.width + x + 1;
          topPixel = (y - 1) * img.width + x;
        }
        if (y != height) {
          btmRightPixel = (y + 1) * img.width + x + 1;
          btmPixel = (y + 1) * img.width + x;
        }
      }
      
      
    }
  }
  
  updatePixels();
}