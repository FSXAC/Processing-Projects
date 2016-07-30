import processing.video.*;

Capture video;
PImage previous;
float threshold;

void setup() {
  size(640, 480);
  video = new Capture(this, width, height, 30);
  video.start();
  previous = createImage(video.width,video.height,RGB);
}

void draw() {
  // map threshold
  threshold = map(mouseX, 0, width, 10, 150);
  
  // Capture video
  if (video.available()) {
    previous.copy(video,0,0,video.width,video.height,0,0,video.width,video.height); // Before we read the new frame, we always save the previous frame for comparison!
    previous.updatePixels();
    video.read();
  }
  
  loadPixels();
  
  // Begin loop to walk through every pixel
  for (int x = 0; x < video.width; x ++ ) {
    for (int y = 0; y < video.height; y ++ ) {
      
      int index = x + y*video.width;
      color a = video.pixels[index];
      color b = previous.pixels[index];

      float diff = dist(red(a), green(a), blue(a), red(b), green(b), blue(b));
      
      if (diff > threshold) { 
        pixels[index] = color(0);
      } else {
        pixels[index] = color(255);
      }
    }
  }
  updatePixels();
  
  fill(0);
  text(threshold, 10, 10);
}