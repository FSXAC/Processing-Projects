// resize the image to mouse position

// import image
PImage img;

// setup
void setup() {
  size(1000, 750);
  img = loadImage("/../boat_resized.jpg");
}

void draw() {
  background(0);
  imageMode(CENTER);
  image(img, width / 2, height / 2, 
  img.width * map(abs(mouseX - width / 2), 0, width / 2, 0, 1),
  img.height * map(abs(mouseY - height / 2), 0, height / 2, 0, 1));
}