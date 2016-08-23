Body[] bodies = new Body[10];;
PVector gravity = new PVector(0, 0.2);

void setup() {
  // screen
  size(1280, 720);
  
  // initialize an array of bodies
  for (int i = 0; i < bodies.length; i++) {
    bodies[i] = new Body(i+1);
  }
}

void draw() {
  background(0, 0, 50);
  
  for (Body b:bodies) {
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
    bodies[i] = new Body(i+1);
  }
}