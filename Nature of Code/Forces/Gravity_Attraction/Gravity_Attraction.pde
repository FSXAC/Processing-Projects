// gravity based on a single fixed point

Body[] bodies = new Body[20];

// new attractor object
Attractor blackhole;

void setup() {
  // screen
  size(1280, 720);
  background(0, 0, 50);
  
  // initialize an array of bodies
  for (int i = 0; i < bodies.length; i++) {
    bodies[i] = new Body(1, new PVector(width / 2, map(i, 0, bodies.length, 50, height / 2 - 20)), new PVector(1, 0));
  }
  
  // initialize attractor
  blackhole = new Attractor(50, width / 2, height / 2);
}

void draw() {
  //background(0, 0, 50);
  
  // draw attractor
  blackhole.display();
  
  for (Body b:bodies) {
    // assume no friction in space
    // three ways of implementing attraction
    // [1]: function that receives both body and attractor
    //attract(blackhole, b);
    // [2]: attractor attraction function
    //blackhole.attract(b);
    // [3]: body attraction function
    b.attractTo(blackhole);
    
    // update
    b.update();;
    b.display();
  }

  println("attractor mass: " + str(blackhole.mass));
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

void keyPressed() {
  if (keyCode == 32) {
    // reset balls (ordered);
    background(0, 0, 50);
    for (int i = 0; i < bodies.length; i++) {
      float y = map(i, 0, bodies.length, 50, height / 2 - 50);
      float altitude = abs((width / 2) - y);
      float orbitSpeed = sqrt(blackhole.mass / altitude);
      
      //bodies[i] = new Body(1, new PVector(width / 2, y), new PVector(1, 0));
      bodies[i] = new Body(1, new PVector(width / 2, y), new PVector(orbitSpeed + 0.1, 0));
      print(altitude, ":");
    }
  } else if (keyCode == UP) {
    blackhole.setMass(blackhole.mass + 10);
  } else if (keyCode == DOWN) {
    blackhole.setMass(blackhole.mass - 10);
  }
}