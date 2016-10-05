class Food {
  PVector location;
  float amount, regen, spawn, size;
  
  Food(PVector pos) {
    location = new PVector(pos.x, pos.y);
    amount = 1000;
    regen = 0.01;
    spawn = 2000;
    size = map(amount, 0, 1000, 0, 40);
  }
  
  void display() {
    pushMatrix();
    translate(location.x, location.y);
    ellipse(0, 0, size, size);
    popMatrix();
  }
}