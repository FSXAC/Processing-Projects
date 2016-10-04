class Body {
  float size;
  PVector position, prev_position;
  PVector velocity;
  PVector acceleration = new PVector(0, 0);
  
  Body(float m) {
    size = m;
    position = new PVector(random(size, width - size),
    random(this.size, height - size));
    prev_position = position;
    velocity = new PVector(random(-1, 1), random(-1, 1));
  }
  
  Body(float m, PVector v) {
    size = m;
    position = new PVector(random(size, width - size),
    random(size, height - size));
    prev_position = position;
    velocity = v;
  }
  
  Body(float m, PVector p, PVector v) {
    size = m;
    position = p;
    prev_position = position;
    velocity = v;
  }
  
  void applyForce(PVector force) {
    PVector applied = PVector.div(force, size);
    acceleration.add(applied);
  }
  
  void applyUForce(PVector force) {
    acceleration.add(force);
  }

  void display() {
    line(position.x, position.y, prev_position.x, prev_position.y);
    update();
  }
  
  void update() {
    // updates the current state of the body
    // physics
    prev_position = position;
    velocity.add(acceleration);
    position.add(velocity); 
    
    // reset acceleration
    acceleration.mult(0);
    
    if (WRAP_SCREEN) {
      checkBoundary();
    }
  }
  
  void checkBoundary() {
    if (position.x < 0) {
      // left
      position.x = width;
    } else if (position.x > width) {
      // right
      position.x = 0;
    }
    if (position.y < 0) {
      // top
      position.y = height;
    } else if (position.y > height) {
      // bottom
      position.y = 0;
    }
  }
  
  void attractTo(Attractor a) {
    // get unit vector of direction first
    PVector force = PVector.sub(a.position, position).normalize();
    force.mult(a.mass * size);
    force.div(PVector.sub(a.position, position).magSq());  
    applyForce(force); 
  }
}