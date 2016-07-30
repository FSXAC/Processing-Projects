import processing.video.*;

Capture video;
float threshold;
color referencePixel;

int xAverage, yAverage, count;
int xMin, yMin;

float diff;

void setup() {
  size(640, 480);
  video = new Capture(this, width, height, 30);
  video.start();
}

void draw() {
  // reset average position
  xAverage = 0;
  yAverage = 0;
  count = 0;
  float valueMin = 255;
  
  // map threshold
  threshold = map(mouseX, 0, width, 5, 50);
  
  // Capture video
  if (video.available()) {
    video.read();
  }
  
  loadPixels();
  
  // Begin loop to walk through every pixel
  for (int x = 0; x < video.width; x ++ ) {
    for (int y = 0; y < video.height; y ++ ) {
      int index = x + y*video.width;

      color a = video.pixels[index];
      
      diff = dist(red(a), green(a), blue(a), 
      red(referencePixel), green(referencePixel), blue(referencePixel));
      
      
      // CLOSEST MODE
      if (diff < valueMin) {
        xMin = x;
        yMin = y;
        valueMin = diff;
      }
      
      // AVERAGE MODE
      //if (diff < threshold) {
      //  xAverage += x;
      //  yAverage += y;
      //  count++;
      //}
      
      pixels[index] = a;
    }
  }
  updatePixels();
  
  // draw circle
  // AVERAGE MODE
  //if (count != 0) {
  //  fill(referencePixel, 150);
  //  stroke(referencePixel);
  //  strokeWeight(3);
  //  ellipse(xAverage / count, yAverage / count, sqrt(count) + 3, sqrt(count) + 3);
  //}
  
  // CLOSEST MODE
  fill(referencePixel, 150);
  stroke(referencePixel);
  strokeWeight(3);
  ellipse(xMin, yMin, sqrt(diff), sqrt(diff));
  
  fill(0);
  text(threshold, 10, 10);
}

void mousePressed() {
  referencePixel = video.pixels[mouseX + mouseY * width];
}