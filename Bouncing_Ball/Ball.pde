class Ball {
  PVector position;
  float radius;
  int color_R, color_G, color_B;
  float vel_x, vel_y;
  float elsticity = random(-0.8, -0.1);
  
  Ball(float x, float y) {
    position = new PVector(x, y);
    this.radius = int(random(2, 20));
    this.color_R = int(random(0, 50));
    this.color_G = int(random(50, 255));
    this.color_B = int(random(0, 50));
    
    this.vel_x = random(-5, 5);
    this.vel_y = random(-5, 5);
  }
  
  void drawBall() {
    noStroke();
    if (vel_y > 0) {
      fill(color_R, color_G, color_B);
    } else {
      fill(color_B, color_R, color_G);
    }
    
    ellipse(position.x, position.y, radius, radius);
  }
  
  void update(float acceleration) {
    // update velocity
    vel_y += acceleration;
    
    // update position
    position.x += vel_x;
    position.y += vel_y;
    
    // check boundary collision
    if (position.x >= width) {
      vel_x *= -1;
      position.x = width - radius;
    }
    if (position.x <= 0) {
      vel_x *= -1;
      position.x = radius;
    }
    if (position.y >= height) {
      vel_y *= elsticity;
      position.y = height - radius;
    }
    if (position.y <= 0) {
      vel_y *= elsticity;
      position.y = 0 + radius;
    } 
  }
}