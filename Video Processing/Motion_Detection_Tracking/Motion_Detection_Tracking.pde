import processing.video.*;

Capture video;
PImage previous;
float threshold;

int xAverage, yAverage, count;
boolean showMotion = true, mouseThreshold = true;

void setup() {
  size(640, 480);
  video = new Capture(this, width, height, 30);
  video.start();
  previous = createImage(video.width,video.height,RGB);
}

void draw() {
  // map threshold
  if (mouseThreshold) threshold = map(mouseX, 0, width, 10, 150);
  
  // reset tracking vars
  xAverage = 0;
  yAverage = 0;
  count = 0;
  
  // Capture video
  if (video.available()) {
    previous.copy(video,0,0,video.width,video.height,0,0,video.width,video.height);
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
        // exists motion
        if (showMotion) pixels[index] = color(0);
        
        // gets average position for tracking
        xAverage += x;
        yAverage += y;
        count++;
      } else {
        // no motion
        if (showMotion) pixels[index] = color(255);
      }
      
      if (!showMotion) pixels[index] = a;
    }
  }
  updatePixels();
  
  // show ellipse on average position of motion
  noFill();
  stroke(200, 0, 0);
  strokeWeight(3);
  if (count != 0) {
    ellipse(xAverage / count, yAverage / count, sqrt(count) + 3, sqrt(count) + 3);
  }
  // show threshold
  fill(255);
  text(threshold, 10, 10);
}

void mousePressed() {
  if (showMotion) showMotion = false;
  else showMotion = true;
}

void keyPressed() {
  if (mouseThreshold) mouseThreshold = false;
  else mouseThreshold = true;
}