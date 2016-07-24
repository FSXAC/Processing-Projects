// Random Rectangles the reveal images


// load image
PImage img;

int x, y, alpha;
int group = 100;
boolean runOnce = true;

// setup
void setup() {
  img = loadImage("/../boat_resized.jpg");
  size(1000, 750);
  noStroke();
  background(0);
  
  if (runOnce) {
    noLoop();
    group *= 100;
  }
}

void draw() {
  // draw rectangles
  for (int i = 0; i < group; i++) {
    x = int(random(0, width));
    y = int(random(0, height));
    alpha = int(random(25, 70));
    rectMode(CENTER);
    fill(img.pixels[int(y) * width + int(x)], alpha);
    rect(x, y, int(random(5, 80)), int(random(5, 40)), int(random(7, 20)));
  }
}