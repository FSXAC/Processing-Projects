// Ecosystem thing

// eaters

// hunters
ArrayList<Hunter> hunters = new ArrayList<Hunter>();

// eaters
ArrayList<Eater> eaters = new ArrayList<Eater>();

// camera
float translateX = 0, translateY = 0, scaleFactor = 1;

void setup() {
  size(800, 800);
  
  // create the first ever hunter
  hunters.add(new Hunter(true));
  
  // more
  for (int i = 0; i < 1; i++) {
    hunters.add(new Hunter(false));
  }
  
  // create 4 new eaters
  //for (int i = 0; i < 1; i++) {
  //  eaters.add(new Eater());
  //}
}

void draw() {
  background(255);
  
  // render hunters
  pushMatrix();
  
  translate(translateX, translateY);
  scale(scaleFactor);
  
  render();
  popMatrix();
  
}

void render() {
  // render hunters
  for (Hunter hunter:hunters) {
    hunter.display();
  }
  
  // render eaters
  for (Eater eater:eaters) {
    eater.display();
  }
}