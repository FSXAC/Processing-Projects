import processing.video.*;

Capture video;

int index;
int radius;

void setup() {
  size(640, 480);
 
  video = new Capture(this, 640, 480, 30);
  video.start();
}

void captureEvent(Capture video) {
  video.read();
}

void draw() {
  video.loadPixels();
  background(0);
  radius = int(map(mouseX, 0, width, 4, 100));
  
  for (int x = 0; x < video.width; x += radius * 2) {
    for (int y = 0; y < video.height; y += radius * 2) {
      
      // get index
      index = y * video.width + x;
      
      fill(img.pixels[index]);
      ellipse(x, y, radius * 2, radius * 2);
    }
  }
}