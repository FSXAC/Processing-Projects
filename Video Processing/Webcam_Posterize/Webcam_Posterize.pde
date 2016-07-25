import processing.video.*;

Capture video;

int index;

void setup() {
  size(640, 480);
 
  video = new Capture(this, 640, 480, 30);
  video.start();
}

void captureEvent(Capture video) {
  video.read();
}

void draw() {
  loadPixels();
  
  for (int x = 0; x < video.width; x++) {
    for (int y = 0; y < video.height; y++) {
      
      // get index
      index = y * video.width + x;
      
      // get brightness
      float bright = brightness(video.pixels[index]);
      
      if (bright > 200) {
        pixels[index] = color(250, 250, 250);
      } else if (bright > 150) {
        pixels[index] = color(175, 175, 175);
      } else if (bright > 100) {
        pixels[index] = color(110, 110, 110);
      } else if (bright > 50) {
        pixels[index] = color(55, 55, 55);
      } else {
        pixels[index] = color(0, 0, 0);
      }
    }
  }
  
  updatePixels();
}