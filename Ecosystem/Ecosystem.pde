// Ecosystem thing

// eaters

// hunters
ArrayList<Hunter> hunters = new ArrayList<Hunter>();

void setup() {
  size(800, 800);
  
  // create the first ever hunter
  hunters.add(new Hunter(true));
}

void draw() {
  background(255);
  
  // render hunters
  render();
}

void render() {
  // render hunters
  for (Hunter hunter:hunters) {
    hunter.display();
  }
}