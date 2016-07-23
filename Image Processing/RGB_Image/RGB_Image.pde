// pixel array intro
// click to cycle through different RGB modes

// load image
PImage img;

// mode (0 = full, 1 = R, 2 = G, 3 = B, 4 = B&W)
int mode = 0;

// setup
void setup() {
  img = loadImage("/../boat_resized.jpg");
  size(1000, 750);
}

void draw() {
  loadPixels();
  
  // loop through all pixels
  for (int x = 0; x < img.width; x++) {
    for (int y = 0; y < img.height; y++) {
      // get index from loop
      int index = y * img.width + x;
      
      // get rgb values from source pixels
      float r = red(img.pixels[index]);
      float g = green(img.pixels[index]);
      float b = blue(img.pixels[index]);
      
      // create new color based on mode
      color newPixel;
      if (mode == 0) {
        // full spectrum
        newPixel = color(r, g, b);
      } else if (mode == 1) {
        // R only
        newPixel = color(r, 0, 0);
      } else if (mode == 2) {
        // G only
        newPixel = color(0, g, 0);
      } else {
        // B only
        newPixel = color(0, 0, b);
      }
      
      // load pixels
      pixels[index] = newPixel;
    }
  }
  
  updatePixels();
}

// change mode on mouse click
void mousePressed() {
  if (mode != 3) {
    mode++;
  } else {
    mode = 0;
  }
}