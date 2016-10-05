class Eater{
  // Physics
  PVector position, targetPosition, velocity, acceleration, force;
  
  // Environmental
  float life, maxSpeed, range, vision, foodVision, size;
  
  // render
  float angle, targetAngle;
  
  Eater() {
    position = new PVector(random(0, width), random(0, height));
    targetPosition = new PVector(random(0, width), random(0, height));
    
    println(position);
    
    velocity = new PVector(0, 0);
    acceleration = new PVector(0, 0);
    force = new PVector(0, 0);
    
    // env
    life = 100;
    maxSpeed = 1 + life / 100;
    vision = 100;
    foodVision = vision * 4;
    range = 50;
    size = 20;
  }
  
  void display() {
    // display now
    translate(position.x, position.y);
    
    ellipse(0, 0, size, size);
        
    // range display
    noFill();
    ellipse(0, 0, foodVision * 2, foodVision * 2);
    ellipse(0, 0, vision * 2, vision * 2);
    ellipse(0, 0, range * 2, range * 2);
    
    // update after render
    update();
  }
  
  void update() {
    // move towards the food if available
    PVector force = getFood().copy();
    if (force.mag() == 0) {
      // does not find food, randomly roam around
      force.add(random(-1, 1), random(-1, 1));
    }
    
    move(force.normalize());
  }
  
  // check food in range
  PVector getFood() {
    float minDist = foodVision;
    PVector directionToFood = new PVector(0, 0);
    
    for (Hunter hunter:hunters) {
      float distanceToFood = dist(position.x, position.y, hunter.foodPile.location.x, 
      hunter.foodPile.location.y);
      float distanceToHunter = dist(position.x, position.y, 
      hunter.position.x, hunter.position.y);
      
      // attract to hunter's food
      if (distanceToFood <= foodVision && hunter.foodPile.isThere()) {
        if (distanceToFood < minDist) {
          minDist = distanceToFood;
          directionToFood.mult(0);
          directionToFood.add(hunter.foodPile.location.x - position.x, 
          hunter.foodPile.location.y - position.y);
        }
      }
      
      // hide from hunter's sight
      minDist = vision;
      if (distanceToHunter <= vision) {
        if (distanceToHunter < minDist) {
          minDist = distanceToHunter;
          directionToFood.mult(0);
          directionToFood.add(position.x - hunter.position.x, 
          position.y - hunter.position.y);
        }
      }
    }
    
    return directionToFood;
  }
  
  void move(PVector force_norm) {
    acceleration.add(force_norm);
    velocity.add(acceleration).limit(maxSpeed);
    
    targetPosition.add(velocity);
    position.add((targetPosition.x - position.x) * 0.1, 
    (targetPosition.y - position.y) * 0.1);
    
    acceleration.mult(0);
    force.mult(0);
  }
}