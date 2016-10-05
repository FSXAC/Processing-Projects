// rocket heat seeker
// create a bunch of heat seekers
Seeker[] swarm = new Seeker[10];

void setup() {
  // drawing tools
  size(1280, 800);
  background(0);
  
  // initialize all seekers
  for (int i = 0; i < swarm.length; i++) {
    swarm[i] = new Seeker();
  }
}

void draw() {
  // clear screen slowly
  fill(0, 20);
  noStroke();
  rectMode(CORNER);
  rect(0, 0, width, height);
  rectMode(CENTER);
  
  for (Seeker s:swarm) {
    s.chase();
  }
}


void keyPressed() {
  if (key == 'w') {
    // initialize all seekers
    for (int i = 0; i < swarm.length; i++) {
      swarm[i] = new Seeker();
    }
  }
}