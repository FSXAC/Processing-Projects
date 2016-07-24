class Ball {
  // properties
  PVector position, velocity;
  int radius = 10;
  float speedMulti = 1;
  
  // constructor
  Ball(PVector pos) {
    position = pos;
    velocity = new PVector(0, 0);
  }
  
  void display() {
    fill(255);
    ellipse(position.x, position.y, radius * 2, radius * 2);
  }
  
  void update() {
    // move
    position.add(velocity);
    
    // change speed
    if (speedMulti > 0) {
      speedMulti -= FRICTION;
    }
    
    // update speed
    velocity.mult(speedMulti);

    // check boundary collision
    if (position.x > width - radius) {
      velocity.x *= -1;
      position.x = width - radius;
    }
    else if (position.x < radius) {
      velocity.x *= -1;
      position.x = radius;
    }
    if (position.y > height - radius) {
      velocity.y *= -1;
      position.y = height - radius;
    }
    else if (position.y < radius) {
      velocity.y *= -1;
      position.y = radius;
    }
  }
  
  void shoot(PVector pos, PVector vel) {
    speedMulti = 1;
    position = pos;
    velocity = vel;
    velocity.mult(SPEED_FACTOR);
  }
}