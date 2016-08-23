Body[] bodies = new Body[10];
Medium liquid;
PVector gravity = new PVector(0, 0.2);

void setup() {
  // screen
  size(1280, 720);
  
  // initialize an array of bodies
  for (int i = 0; i < bodies.length; i++) {
    bodies[i] = new Body(random(1, 4), map(i, 0, bodies.length, 100, width - 100), 100);
  }
  
  // medium
  liquid = new Medium(0, height/2, width, height, 0.1);
  liquid.setDensity(1);
}

void draw() {
  background(0, 0, 50);
  
  // show liquid
  liquid.display();
  
  for (Body b:bodies) {
    // fluid
    if (b.isInside(liquid)) {
      b.drag(liquid);
    }
    
    // friction calculation
    PVector friction = b.velocity.copy();
    friction.normalize();
    friction.mult(-b.mu);
    
    b.applyUForce(gravity);
    b.applyForce(friction);
    
    // update
    b.update();;
    b.display();
  }
}

void mousePressed() {
  // reset balls
  for (int i = 0; i < bodies.length; i++) {
    bodies[i] = new Body(random(1, 4), map(i, 0, bodies.length, 100, width - 100), 100);
  }
}