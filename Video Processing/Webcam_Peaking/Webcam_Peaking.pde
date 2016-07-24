import processing.video.*;

Capture video;

int index;
int peakingThreshold;

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
      
      // get peaking threshold
      peakingThreshold = int(map(mouseX, 0, width, 0, 255));
      if (brightness(video.pixels[index]) > peakingThreshold) {
        if (y % 6 == 0 || y % 6 == 1 || y % 6 == 2) {
          pixels[index] = color(0, 0, 0);
        } else {
          pixels[index] = color(255, 255, 255);
        }
        
      } else {
        pixels[index] = video.pixels[index];
      }
    }
  }
  
  updatePixels();
  
  // text
  text(peakingThreshold, 10, 10);
}