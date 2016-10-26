class Attractor {
  float mass;
  PVector position = new PVector(0, 0);
  float radius = 10;
  
  Attractor(float m, float x, float y) {
    mass = m;
    position.x = x;
    position.y = y;
  }
  
  void display() {
    fill(255, 0, 0, 150);
    ellipse(position.x, position.y, radius * 2, radius * 2);
    position.x = mouseX;
    position.y = mouseY;
  }
  
  // [2]
  void attract(Body m) {
    // get unit vector of direction first
    PVector force = PVector.sub(position, m.position).normalize();
    force.mult(mass * m.mass);
    force.div(PVector.sub(position, m.position).magSq());  
    m.applyForce(force);
  }
  
  void setRadius(float r) {
    radius = r;
  }
  
  void setMass(float m) {
    mass = m;
  }
}