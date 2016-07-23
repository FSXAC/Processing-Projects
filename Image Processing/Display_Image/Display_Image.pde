// Basic image program

// load the image
PImage boat;

// setup
void setup() {
  boat = loadImage("/../boat_resized.jpg");
  size(1000, 750);
  noLoop();
}

// draw
void draw() {
  //imageMode(CENTER);
  image(boat, 0, 0);
}