class Food {
  PVector location;
  float amount, regen, spawn;
  
  Food(PVector pos) {
    location = pos;
    amount = 1000;
    regen = 0.01;
    spawn = 2000;
  }
}