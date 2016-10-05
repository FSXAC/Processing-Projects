class Hunter {
  // Physics
  PVector position, velocity, acceleration;
  
  // Environmental
  float strength, life, maxSpeed, exp, range, vision;
  
  // Hunter's own food pile
  Food foodPile;
  
  Hunter(boolean isFirstOne) {
    if (isFirstOne) {
      position = new PVector(width / 2, height / 2);
    } else {
      position = new PVector(random(0, width), random(0, height));
    }
    velocity = new PVector(0, 0);
    acceleration = new PVector(0, 0);
    
    strength = 10;
    life = 500;
    maxSpeed = strength / 2;
    range = 300;
    vision = range * 1.5;
    
    // starting with a food pile
    foodPile = new Food(position);    
  }
  
  void display() {
    // set up draw
    stroke(0);
       
    // display current
    pushMatrix();
    translate(position.x, position.y);
    triangle(0, -10, -5, 10, 5, 10);
    popMatrix();
    
    // update after render
    update();
  }
  
  void update() {
    
  }
}