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
  for (int x = 0; x < width; x ++ ) {
    for (int y = 0; y < height; y ++ ) {
      int index = x + y * width;
      int indexM = (width - 1 - x) + y * width;

      color a = video.pixels[index];
      
      diff = dist(red(a), green(a), blue(a), 
      red(referencePixel), green(referencePixel), blue(referencePixel));
      
      
      // CLOSEST MODE
      if (diff < valueMin) {
        xMin = width - 1 -x;
        yMin = y;
        valueMin = diff;
      }
      
      // AVERAGE MODE
      //if (diff < threshold) {
      //  xAverage += x;
      //  yAverage += y;
      //  count++;
      //}
      
      pixels[indexM] = a;
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
  stroke(255 - red(referencePixel), 255 - green(referencePixel), 255 - blue(referencePixel));
  strokeWeight(2);
  ellipse(xMin, yMin, sqrt(diff) + 5, sqrt(diff) + 5);
  strokeWeight(1);
  line(xMin - 10, yMin, xMin + 10, yMin);
  line(xMin, yMin - 10, xMin, yMin + 10);
  
  fill(0);
  //text(threshold, 10, 10);
  text(diff, 10, 10);
}

void mousePressed() {
  referencePixel = video.pixels[width - 1 - mouseX + mouseY * width];
}