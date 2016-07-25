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
      float r = red(video.pixels[index]);
      float g = green(video.pixels[index]);
      float b = blue(video.pixels[index]);
      float maxColor = max(r, g, b);
      
      if (maxColor == r) {
        pixels[index] = color(255, 0, 0);
      } else if (maxColor == g) {
        pixels[index] = color(0, 255, 0);
      } else {
        pixels[index] = color(0, 0, 255);
      }
    }
  }
  
  updatePixels();
}