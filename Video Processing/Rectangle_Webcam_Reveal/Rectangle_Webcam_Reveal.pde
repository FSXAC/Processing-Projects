import processing.video.*;

Capture video;

boolean warpScreen = false;

Rect[] rectangles;

void setup() {
  size(640, 480);
  noStroke();
  
  rectangles = new Rect[100];
  for(int i = 0; i < rectangles.length; i++) {
    rectangles[i] = new Rect(int(random(0, width)), int(random(0, height)));
  }
  
  video = new Capture(this, 640, 480, 30);
  video.start();
}

void captureEvent(Capture video) {
  video.read();
}

void draw() {
  for (int i = 0; i < rectangles.length; i++) {
    rectangles[i].drawRect();
    rectangles[i].update();
  }
}