void setup() {
  size(1280, 720);
  fill(255);
  stroke(255);
  strokeWeight(3);
  background(0);
}

float x, dia = 5, a = 100;

void draw() {
  //background(0);
  ellipse(x, a * cos(x) + (width / 2), dia, dia);
  x+=0.1;
}