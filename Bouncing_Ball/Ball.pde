class Ball {
  float x, y, radius;
  int color_R, color_G, color_B;
  float vel_x, vel_y;
  float elsticity = random(-0.8, -0.4);
  
  Ball(float x, float y) {
    this.x = x;
    this.y = y;
    this.radius = int(random(5, 25));
    this.color_R = int(random(0, 50));
    this.color_G = int(random(50, 255));
    this.color_B = int(random(0, 50));
    
    this.vel_x = random(-5, 5);
    this.vel_y = random(-5, 5);
  }
  
  void drawBall(float acceleration) {
    stroke(0);
    if (acceleration == 1) {
      fill(color_R, color_G, color_B);
    } else {
      fill(color_B, color_R, color_G);
    }
    
    ellipse(x, y, radius, radius);
    
    // update velocity
    vel_y += acceleration;
    
    // update position
    x += vel_x;
    y += vel_y;
    
    // bounce
    if (x >= WIDTH || x <= 0) {
      vel_x *= -1;
    }
    if (y >= HEIGHT) {
      vel_y *= elsticity;
      y = HEIGHT - radius;
    }
    if (y <= 0) {
      vel_y *= elsticity;
      y = 0 + radius;
    }
  }
}