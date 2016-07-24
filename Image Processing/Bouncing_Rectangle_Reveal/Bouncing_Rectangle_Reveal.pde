// Bouncing Rectangles the reveal images


// load image
PImage img;

// rectangle list
int MAX_ENTITY = 500;
int count = 0;
int group = 100;
Rect[] rectangles = new Rect[MAX_ENTITY];

// warp screen
boolean warpScreen = false;

// setup
void setup() {
  img = loadImage("/../boat_resized.jpg");
  size(1000, 750);
  noStroke();
  background(0);
}

void draw() {
  // draw rectangles
  for (int i = 0; i < count; i++) {
    rectangles[i].drawRect();
    rectangles[i].update();
  }
}

// create a bunch of new rectangle on mouse click
void mousePressed() {
  for (int i = 0; i < group; i++) {
    rectangles[count] = new Rect(mouseX + int(random(-20, 20)), mouseY + int(random(-20, 20)));
    count++;
  }
}