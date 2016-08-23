class frictionPocket {
  float mu;
  PVector p1, p2;
  
  frictionPocket(float strength, int x1, int y1, int x2, int y2) {
    mu = strength;
    p1 = new PVector(x1, y1);
    p2 = new PVector(x2, y2);
  }
  
  void display() {
    fill(255, 100);
    rect(p1.x, p1.y, p2.x, p2.y);
  }
}