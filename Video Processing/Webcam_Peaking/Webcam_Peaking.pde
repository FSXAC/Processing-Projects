import processing.video.*;

Capture video;

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
      int index = y * video.width + x;
      
      // new pixel
      pixels[index] = video.pixels[index];
    }
  }
  
  updatePixels();
}