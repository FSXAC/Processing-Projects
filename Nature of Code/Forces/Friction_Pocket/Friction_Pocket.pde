Body[] bodies = new Body[10];
frictionPocket pocket;
PVector gravity = new PVector(0, 0.2);

void setup() {
  // screen
  size(1280, 720);
  
  // initialize an array of bodies
  for (int i = 0; i < bodies.length; i++) {
    bodies[i] = new Body(i+1);
  }
  
  // initialize friction pocket
  pocket = new frictionPocket(0.5, 0, height / 2, width, height);
}

void draw() {
  background(0, 0, 50);
  
  for (Body b:bodies) {
    // friction calculation
    b.checkFriction(pocket);
    PVector friction = b.velocity.copy();
    friction.normalize();
    friction.mult(-b.mu);

    b.applyUForce(gravity);
    b.applyForce(friction);
    
    // update
    b.update();
    b.display();
  }
  
  // display friction zone
  pocket.display();
}

void mousePressed() {
  // reset balls
  for (int i = 0; i < bodies.length; i++) {
    bodies[i] = new Body(i+1);
  }
}