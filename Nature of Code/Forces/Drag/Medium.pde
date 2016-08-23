class Medium {
  float x1, y1, x2, y2;
  float drag_coefficient;
  float density = 0.5;
  
  Medium(float x1_, float y1_, float x2_, float y2_, float drag) {
    x1 = x1_;
    y1 = y1_;
    x2 = x2_;
    y2 = y2_;
    drag_coefficient = drag;
  }
  
  void display() {
    noStroke();
    fill(255, map(density, 0, 1, 0, 150));
    rect(x1, y1, x2, y2);
  }
  
  void setDensity(float newDensity) {
    density = newDensity;
  }
}