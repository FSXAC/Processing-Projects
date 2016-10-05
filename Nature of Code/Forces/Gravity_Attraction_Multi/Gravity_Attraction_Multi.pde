// gravity based on multiple points

Body[] bodies = new Body[200];

// new attractor arrays
Attractor[] attractors = new Attractor[1];

// wrap screen config
boolean WRAP_SCREEN = false;

// camera
Camera worldCamera = new Camera();

void setup() {
  // screen
  size(1280, 720);
  background(0);
  smooth();
    
  // initialize an array of bodies with a single pixel
  for (int i = 0; i < bodies.length; i++) {
    //bodies[i] = new Body(1, new PVector(width / 2, map(i, 0, bodies.length, 50, height / 2 - 20)), new PVector(1, 0));
    //bodies[i] = new Body(0.5, new PVector(random(0, width), random(0, height)), new PVector(random(-1, 1), random(-1, 1)));
    //bodies[i] = new Body(0.5, new PVector(random(0, width), random(0, height)), new PVector(1, 0));
    //bodies[i] = new Body(0.5, new PVector(width / 2 + random(-5, 5), height / 2 + random(-5, 5)), new PVector(1, 0));
    bodies[i] = new Body(1, new PVector(width / 2 + random(-5, 5), height / 2 + random(-5, 5)), new PVector(random(-1, 1), random(-1, 1)));
    //bodies[i] = new Body(1, new PVector(map(i, 0, bodies.length, 0, width), 0), new PVector(1, 0));
  }
  
  // initialize attractors
  for (int i = 0; i < attractors.length; i++) {
    attractors[i] = new Attractor(random(500, 1000), random(0, width), random(0, height));
  }
}

void draw() {
  // camera
  translate(-worldCamera.pos.x, -worldCamera.pos.y);
  worldCamera.draw();
  
  //background(0, 0, 0);
  // fading background;
  fill(0, 10);
  noStroke();  
  rect(0, 0, width, height);
  
  
  for (int i=0; i < 2; i++) {
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

    // draw
    b.display();
  }
  }
}

// [1]
void attract(Attractor a, Body mass) {
  // get unit vector of direction first
  PVector force = PVector.sub(a.position, mass.position).normalize();
  force.mult(a.mass * mass.size);
  force.div(PVector.sub(a.position, mass.position).magSq());  
  mass.applyForce(force);
}

class Camera {
  PVector pos; //Camera's position 
  //The Camera should sit in the top left of the window
 
  Camera() {
    pos = new PVector(0, 0);
    //You should play with the program and code to see how the staring position can be changed
  }
 
  void draw() {
    //I used the mouse to move the camera
    //The mouse's position is always relative to the screen and not the camera's position
    //E.g. if the mouse is at 1000,1000 then the mouse's position does not add 1000,1000 to keep up with the camera
    //if (mouseX < 100) pos.x-=5;
    //else if (mouseX > width - 100) pos.x+=5;
    // if (mouseY < 100) pos.y-=5;
    //else if (mouseY > height - 100) pos.y+=5;
    //I noticed on the web the program struggles to find the mouse so I made it key pressed
    if (keyPressed) {
      if (key == 'w') pos.y -= 5;
      if (key == 's') pos.y += 5;
      if (key == 'a') pos.x -= 5;
      if (key == 'd') pos.x += 5;
    }
  }
}