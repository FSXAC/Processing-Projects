// Ecosystem thing

// eaters

// hunters
ArrayList<Hunter> hunters = new ArrayList<Hunter>();

// eaters
ArrayList<Eater> eaters = new ArrayList<Eater>();

// camera
float translateX, translateY, scaleFactor;

void setup() {
  size(800, 800);
  
  // create the first ever hunter
  hunters.add(new Hunter(true));
  
  // create 4 new eaters
  for (int i = 0; i < 4; i++) {
    eaters.add(new Eater());
  }
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

void mouseWheel(MouseEvent e)
{
  scaleFactor += e.getAmount() / 100;
 
  translateX -= e.getAmount() * mouseX / 100;
 
  translateY -= e.getAmount() * mouseY / 100;
}