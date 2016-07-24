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
      
      // get distance to cursor
      float distance = sqrt(pow((mouseX - x), 2) + pow((mouseY - y), 2));
      
      // normalize distance to multiplication factor
      distance = (300 - distance) / 300;
      
      // load pixels
      //pixels[index] = color(r * (1 - distance), g * distance, b * (1 - distance));
      pixels[index] = color(r * distance, g * distance, b * distance);
    }
  }
  
  updatePixels();
}