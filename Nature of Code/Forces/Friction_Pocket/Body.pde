class Body {
  float mass;
  float radius;
  float elasticity = 1;
  float default_mu = 0.01;
  float mu = default_mu;
  boolean inPocket = false;
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
    radius = m * 10;
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
    if (inPocket) {
      fill(150, 0, 0, 150);
    } else {
      fill(255, 150);
    }
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
  
  void checkFriction(frictionPocket pocket) {
    // check if it's inside the pocket
    if ((position.x > pocket.p1.x && position.x < pocket.p2.x) &&
    (position.y > pocket.p1.y && position.y < pocket.p2.y)) {
      mu = pocket.mu;
      inPocket = true;
    } else {
      mu = default_mu;
      inPocket = false;
    }
  }
}