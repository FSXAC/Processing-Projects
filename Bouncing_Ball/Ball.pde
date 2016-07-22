class Ball {
  PVector position, velocity;
  float radius;
  int color_R, color_G, color_B;
  float elsticity = random(-0.8, -0.1);
  
  Ball(float x, float y) {
    position = new PVector(x, y);
    velocity = new PVector(random(-5, 5), random(-5, 5));
    this.radius = int(random(2, 20));
    this.color_R = int(random(0, 50));
    this.color_G = int(random(50, 255));
    this.color_B = int(random(0, 50));
  }
  
  void drawBall() {
    noStroke();
    if (velocity.y > 0) {
      fill(color_R, color_G, color_B);
    } else {
      fill(color_B, color_R, color_G);
    }
    
    ellipse(position.x, position.y, radius, radius);
  }
  
  void update(float acceleration) {
    // update velocity
    velocity.y += acceleration;
    
    // update position
    position.x += velocity.x;
    position.y += velocity.y;
    
    // check boundary collision
    if (position.x >= width) {
      velocity.x *= -1;
      position.x = width - radius;
    }
    if (position.x <= 0) {
      velocity.x *= -1;
      position.x = radius;
    }
    if (position.y >= height) {
      velocity.y *= elsticity;
      position.y = height - radius;
    }
    if (position.y <= 0) {
      velocity.y *= elsticity;
      position.y = 0 + radius;
    } 
  }
}