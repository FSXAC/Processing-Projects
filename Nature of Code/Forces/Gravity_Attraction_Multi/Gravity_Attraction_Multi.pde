// gravity based on multiple points

Body[] bodies = new Body[200];

// new attractor arrays
Attractor[] attractors = new Attractor[2];

void setup() {
  // screen
  size(1280, 720);
  background(0, 0, 0);
  
  // initialize an array of bodies with a single pixel
  for (int i = 0; i < bodies.length; i++) {
    //bodies[i] = new Body(1, new PVector(width / 2, map(i, 0, bodies.length, 50, height / 2 - 20)), new PVector(1, 0));
    //bodies[i] = new Body(0.5, new PVector(random(0, width), random(0, height)), new PVector(random(-1, 1), random(-1, 1)));
    //bodies[i] = new Body(0.5, new PVector(random(0, width), random(0, height)), new PVector(1, 0));
    //bodies[i] = new Body(0.5, new PVector(width / 2 + random(-5, 5), height / 2 + random(-5, 5)), new PVector(1, 0));
    bodies[i] = new Body(0.5, new PVector(width / 2 + random(-5, 5), height / 2 + random(-5, 5)), new PVector(random(-1, 1), random(-1, 1)));
  }
  
  // initialize attractors
  for (int i = 0; i < attractors.length; i++) {
    attractors[i] = new Attractor(random(100, 500), random(0, width), random(0, height));
  }
}

void draw() {
  //background(0, 0, 50);
   
  for (Body b:bodies) {
    // assume no friction in space
    // three ways of implementing attraction
    // [1]: function that receives both body and attractor
    //attract(blackhole, b);
    // [2]: attractor attraction function
    //blackhole.attract(b);
    // [3]: body attraction function
    
    // draw attractors
    for (Attractor a:attractors) {
      a.display();
      b.attractTo(a);
    }

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
    bodies[i] = new Body(0.1);
  }
}