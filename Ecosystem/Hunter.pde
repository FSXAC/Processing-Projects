class Hunter {
  // Physics
  PVector position, velocity, acceleration, force, vision;
  //PVector targetPosition;
  
  // Environmental
  float strength, life, maxSpeed, exp, range, visionRange;
  
  // render
  float angle, targetAngle;
  
  // Hunter's own food pile
  Food foodPile;
  float distToFood;
  
  Hunter(boolean isFirstOne) {
    // initalize phys
    if (isFirstOne) {
      position = new PVector(width / 2, height / 2);
      //targetPosition = new PVector(width / 2, height / 2);
    } else {
      position = new PVector(random(0, width), random(0, height));
      //targetPosition = new PVector(random(0, width), random(0, height));
    }
    velocity = new PVector(0, 0);
    acceleration = new PVector(0, 0);
    force = new PVector(0, 0);
    
    // env
    strength = 5;
    life = 500;
    maxSpeed = strength;
    range = 50;
    visionRange = range * 2;
    
    // vision
    vision = new PVector(position.x, position.y - visionRange);
    
    // starting with a food pile
    exp = 1001;
    foodPile = new Food(position.x, position.y);    
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
    ellipse(0, -visionRange, visionRange * 2, visionRange * 2);
    line(0, 0, 0, -visionRange);
    popMatrix();

    // update after render
    update();
  }
  
  void update() {
    // sight
    vision.set(position.x + cos(angle) * visionRange, position.y + sin(angle) * visionRange);
    
    if (foodPile.isThere()) {      
      // apply force onto hunter around the food pile
      guard();
    } else {
      // either roam around randomly or chase
      
      
      // if there is enough experience, create a new foodpile
      if (exp >= 1000) {
        foodPile = new Food(position.x + random(-10, 10), 
        position.y + random(-10, 10));
        exp = 0;
      }
    }
  }
  
  void guard() {
    distToFood = dist(position.x, position.y, foodPile.location.x, foodPile.location.y);
    if (distToFood < range) {
      // when defending (act random inside the radius of food pile)
      force.add(random(-1, 1), random(-1, 1));
    } else {
      // turn back
      force.add(foodPile.location.x - position.x, foodPile.location.y - position.y);
    }
    
    // move
    move(force.normalize());
  }
  
  void roam() {
    force.add(random(-1, 1), random(-1, 1));
    move(force.normalize());
    
    // if there is any eaters in range, chase them with priority
    
  }
  
  void move(PVector force_norm) {
    acceleration.add(force_norm);
    velocity.add(acceleration).limit(maxSpeed);
    
    //targetPosition.add(velocity);
    //position.add((targetPosition.x - position.x) * 0.1, 
    //(targetPosition.y - position.y) * 0.1);
    position.set(lerp(position.x, position.x+velocity.x, 1), 
    lerp(position.y, position.y+velocity.y, 1));
    
    acceleration.mult(0);
    force.mult(0);
  }
}