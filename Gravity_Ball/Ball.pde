class Ball {
  PVector position, velocity, acceleration;
  float radius, mass;
  int color_R, color_G, color_B;
  boolean fixed = false;
  
  Ball(float x, float y) {
    // physics
    position = new PVector(x, y);
    //velocity = PVector.random2D();
    velocity = new PVector(0, 0);
    acceleration = new PVector(0, 0);
    
    // body
    //radius = int(random(2, 10));
    radius = 10;
    mass = radius;
    
    // color
    color_R = int(random(50, 255));
    color_G = int(random(50, 255));
    color_B = int(random(50, 255));
  }
  
  void drawBall() {
    fill(color(color_R, color_G, color_B));
    ellipse(position.x, position.y, radius * 2, radius * 2);
  }
  
  void update() {
    
    if (!fixed) {
      // update position
      position.add(velocity);
      
      // update velocity
      velocity.add(acceleration);
    }
  }
  
  void gravitate(Ball other) {
    float r_x = other.position.x - position.x;
    float r_y = other.position.y - position.y;
    float distance = dist(position.x, position.y, other.position.x, other.position.y);
    float force = 0.1 * mass * other.mass / pow(distance, 2);
    float scalarAcceleration = force / mass;
    
    PVector newAcceleration = new PVector(scalarAcceleration * r_x / distance, 
    scalarAcceleration * r_y / distance);
    
    acceleration.add(newAcceleration);
  }
  
  void setFixed() {
    fixed = true;
  }
}