Body[] bodies;
PVector gravity = new PVector(0, 0.2);

void setup() {
  // screen
  size(1280, 720);
  
  // initialize an array of bodies
  bodies = new Body[10];
  for (int i = 0; i < bodies.length; i++) {
    bodies[i] = new Body(i+1);
  }
}

void draw() {
  background(0, 0, 50);
  
  for (Body b:bodies) {
    b.applyForce(PVector.mult(gravity, b.mass));
    
    // update
    b.update();;
    b.display();
  }   
}