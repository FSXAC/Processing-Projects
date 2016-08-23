class Body {
  float mass;
  float radius;
  float elasticity = 1;
  float mu = 0.00;
  PVector position;
  PVector velocity;
  PVector acceleration = new PVector(0, 0);
  
  Body(float m, float x, float y) {
    mass = m;
    radius = m * 10;
    position = new PVector(x, y);
    //velocity = new PVector(random(-1, 1), random(-1, 1));
    velocity = new PVector(0, 0);
  }
  
  void applyForce(PVector force) {
    PVector applied = PVector.div(force, mass);
    acceleration.add(applied);
  }
  
  void applyUForce(PVector force) {
    acceleration.add(force);
  }
  
  // applies drag force
  void drag(Medium m) {
    PVector drag = velocity.copy();
    
    // reverse direction and get unit vector
    drag.mult(-1).normalize();
    
    // complete the equation F_d = -\rho*v^2*A*C_d*v_hat
    drag.mult(m.drag_coefficient * m.density * velocity.magSq());
    
    // accumulate force
    applyForce(drag);
  }

  void display() {
    noStroke();
    fill(255, 200);
    ellipse(position.x, position.y, radius * 2, radius * 2);
  }
  
  void update() {
    // updates the current state of the body
    // physics
    velocity.add(acceleration);
    position.add(velocity);
    
    // reset acceleration
    acceleration.mult(0);
    
    checkBoundary();
  }
  
  void checkBoundary() {
    if (position.x < radius) {
      // left
      position.x = radius;
      velocity.x *= -elasticity;
    } else if (position.x > width - radius) {
      // right
      position.x = width - radius;
      velocity.x *= -elasticity;
    }
    if (position.y < radius) {
      // top
      position.y = radius;
      velocity.y *= -elasticity;
    } else if (position.y > height - radius) {
      // bottom
      position.y = height - radius;
      velocity.y *= -elasticity;
    }
  }
  
  float getArea() {
    return PI * radius * radius;
  }
  
  boolean isInside(Medium m) {
    if ((position.x > m.x1 && position.x < m.x2) && (position.y > m.y1 && position.y < m.y2)) {
      return true;
    } else {
      return false;
    }
  }
}