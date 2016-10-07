class Food {
  PVector location;
  float amount, regen, spawn, size;
  
  Food(float x, float y) {
    location = new PVector(x, y);
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
    
    // testing shrinking
    if (amount > 0) {
      size = map(amount, 0, 1000, 0, 40);
    }
  }
  
  // getter for checking if food pile still exists
  boolean isThere() {
    return (amount > 0);
  }
}