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
  }
  
  void setRadius(float r) {
    radius = r;
  }
}