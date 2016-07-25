// Image spotlight

// load the image
PImage img;

int radius;

// setup
void setup() {
  img = loadImage("/../boat_resized.jpg");
  size(1000, 750);
  noStroke();
}

// draw
void draw() {
  img.loadPixels();
  
  background(0);
  radius = int(map(mouseX, 0, width, 4, 100));
  
  // loop through all pixels
  for (int x = 0; x < img.width; x += radius * 2) {
    for (int y = 0; y < img.height; y += radius * 2) {
      // get index from loop
      int index = y * img.width + x;

      fill(img.pixels[index]);
      ellipse(x, y, radius * 2, radius * 2);
    }
  }
}