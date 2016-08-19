class Body {
  float mass;
  float radius;
  float elasticity = 0.5;
  PVector position, velocity;
  PVector acceleration = new PVector(0, 0);
  
  Body(float m) {
    mass = m;
    radius = m * 10;
    this.position = new PVector(random(radius, width - radius),
    random(this.radius, height - radius));
    //position = new PVector(width/2, height/2);
    //velocity = new PVector(0, 0);
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
    this.acceleration.add(applied);
  }

  void display() {
    noStroke();
    fill(255, 150);
    ellipse(position.x, position.y, radius * 2, radius * 2);
  }
  
  void update() {
    // updates the current state of the body
    // physics
    position.add(velocity);
    velocity.add(acceleration);
    acceleration.mult(0);
    //this.velocity.limit(10);
    
    // boundary detection
    if (position.x < radius) {
      // left
      position.x = this.radius;
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
}