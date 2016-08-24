class Body {
  float mass;
  float radius;
  float elasticity = 1;
  float mu = 0.00;
  boolean collideBoundary = false;
  PVector position;
  PVector velocity;
  PVector acceleration = new PVector(0, 0);
  
  Body(float m) {
    mass = m;
    radius = m * 10;
    this.position = new PVector(random(radius, width - radius),
    random(this.radius, height - radius));
    velocity = new PVector(random(-1, 1), random(-1, 1));
  }
  
  Body(float m, PVector v) {
    mass = m;
    radius = m * 10;
    position = new PVector(random(radius, width - radius),
    random(radius, height - radius));
    velocity = v;
  }
  
  Body(float m, PVector p, PVector v) {
    mass = m;
    radius = m * 3;
    position = p;
    velocity = v;
  }
  
  void applyForce(PVector force) {
    PVector applied = PVector.div(force, mass);
    acceleration.add(applied);
  }
  
  void applyUForce(PVector force) {
    acceleration.add(force);
  }

  void display() {
    noStroke();
    fill(255, 150);
    ellipse(position.x, position.y, radius * 2, radius * 2);
  }
  
  void update() {
    // updates the current state of the body
    // physics
    velocity.add(acceleration);
    position.add(velocity);
    
    // reset acceleration
    acceleration.mult(0);
    
    if (collideBoundary) {
      checkBoundary();
    }
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
  
  void attractTo(Attractor a) {
    // get unit vector of direction first
    PVector force = PVector.sub(a.position, position).normalize();
    force.mult(a.mass * mass);
    force.div(PVector.sub(a.position, position).magSq());  
    applyForce(force); 
  }
}