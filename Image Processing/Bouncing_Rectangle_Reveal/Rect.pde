class Rect {
  PVector position, velocity;
  int rectWidth, rectHeight;
  int radius;
  int alpha = int(random(25, 70));
  
  Rect(int x, int y) {
    // set position to mouse pos
    position = new PVector(x, y);
    
    // set random velocity
    velocity = PVector.random2D();
    velocity.mult(30);
    
    // radius of rectangle
    radius = int(map(max(rectWidth, rectHeight), 5, 50, 5, 12));

    // set size to random
    rectWidth = int(random(5, 50));
    rectHeight = int(random(5, 50));
  }
  
  void drawRect() {
    // select the pixel color of the image corresponding to the x-y location
    fill(img.pixels[int(position.y) * width + int(position.x)], alpha);
    
    // draw the rectangle
    rect(position.x, position.y, rectWidth, rectHeight, radius);
  }
  
  void update() {
    // move rectangles
    position.add(velocity);
    
    // check boundaries
    if (!warpScreen) {
      // bounce
      if (position.x <= 0) {
        position.x = 0;
        velocity.x *= -1;
        velocity.y += random(-1, 1);
      } else if (position.x + rectWidth >= width) {
        position.x = width - rectWidth;
        velocity.x *= -1;
        velocity.y += random(-1, 1);
      }
      
      if (position.y <= 0) {
        position.y = 0;
        velocity.y *= -1;
        velocity.x += random(-1, 1);
      } else if (position.y + rectHeight >= height) {
        position.y = height - rectHeight;
        velocity.y *= -1;
        velocity.x += random(-1, 1);
      }
    } else {
      // translate to the other side of screen
    }
  }
}