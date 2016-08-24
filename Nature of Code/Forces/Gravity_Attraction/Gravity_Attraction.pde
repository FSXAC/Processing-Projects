// gravity based on a single fixed point

Body[] bodies = new Body[10];

// new attractor object
Attractor blackhole;

void setup() {
  // screen
  size(1280, 720);
  
  // initialize an array of bodies
  for (int i = 0; i < bodies.length; i++) {
    bodies[i] = new Body(random(1,4));
  }
  
  // initialize attractor
  blackhole = new Attractor(200, width / 2, height / 2);
}

void draw() {
  background(0, 0, 50);
  
  // draw attractor
  blackhole.display();
  
  for (Body b:bodies) {
    // assume no friction in space
    // four ways of implementing attraction
    // [1]: function that receives both body and attractor
    
    attract(blackhole, b);
    
    // update
    b.update();;
    b.display();
  }
}

// [1]
void attract(Attractor a, Body mass) {
  // get unit vector of direction first
  PVector force = PVector.sub(a.position, mass.position).normalize();
  force.mult(a.mass * mass.mass);
  force.div(PVector.sub(a.position, mass.position).magSq());  
  mass.applyForce(force);
}

void mousePressed() {
  // reset balls
  for (int i = 0; i < bodies.length; i++) {
    bodies[i] = new Body(random(1, 4));
  }
}