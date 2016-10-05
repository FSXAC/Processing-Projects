class Hunter {
  // Physics
  PVector position, targetPosition, velocity, acceleration, force;
  
  // Environmental
  float strength, life, maxSpeed, exp, range, vision;
  
  // render
  float angle, targetAngle;
  
  // Hunter's own food pile
  Food foodPile;
  float distToFood;
  
  Hunter(boolean isFirstOne) {
    // initalize phys
    if (isFirstOne) {
      position = new PVector(width / 2, height / 2);
      targetPosition = new PVector(width / 2, height / 2);
    } else {
      position = new PVector(random(0, width), random(0, height));
      targetPosition = new PVector(random(0, width), random(0, height));
    }
    velocity = new PVector(0, 0);
    acceleration = new PVector(0, 0);
    force = new PVector(0, 0);
    
    // env
    strength = 5;
    life = 500;
    maxSpeed = strength;
    range = 100;
    vision = range * 2;
    
    // starting with a food pile
    foodPile = new Food(position);    
  }
  
  void display() {
    // display food
    foodPile.display();
    
    // get angle
    targetAngle = velocity.heading() + PI / 2;
    angle += (targetAngle - angle) * 0.5;
       
    // display now
    pushMatrix();
    translate(position.x, position.y);
    
    // point the way its going
    rotate(angle);
    
    triangle(0, -10, -5, 10, 5, 10);
        
    // range display
    noFill();
    ellipse(0, 0, range * 2, range * 2);
    ellipse(0, 0, vision * 2, vision * 2);
    popMatrix();

    // update after render
    update();
  }
  
  void update() {
    distToFood = dist(position.x, position.y, foodPile.location.x, foodPile.location.y);
    if (distToFood < range) {
      // when defending (act random inside the radius of food pile)
      fill(0, 255, 0);
      force.add(random(-1, 1), random(-1, 1));
    } else {
      // turn back
      fill(255, 0, 0);
      force.add(foodPile.location.x - position.x, foodPile.location.y - position.y);
    }
    acceleration.add(force.normalize());
    velocity.add(acceleration).limit(maxSpeed);
    
    targetPosition.add(velocity);
    position.add((targetPosition.x - position.x) * 0.1, 
    (targetPosition.y - position.y) * 0.1);
    
    acceleration.mult(0);
    force.mult(0);
  }
}