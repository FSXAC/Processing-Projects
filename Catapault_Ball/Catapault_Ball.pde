// Catepault mouse guesture test

int MAX_ENTITY = 500;
Ball ball;

// physics constants
float SPEED_FACTOR = 0.1;
float FRICTION = 0.0005;

// vector calculation
PVector start, current, projection, end;

void setup() {
  stroke(150);
  strokeWeight(4);
  size(800, 800);
  
  ball = new Ball(new PVector(width / 2, height / 2));
  projection = new PVector(0, 0);
}

void draw() {
  background(0);
  ball.display();
  ball.update();
  
  if (mousePressed) {
    current = new PVector(mouseX, mouseY);
    projection.x = start.x - (mouseX - start.x);
    projection.y = start.y - (mouseY - start.y);
    line(start.x, start.y, projection.x, projection.y);
  }
}

void mousePressed() {
  start = new PVector(mouseX, mouseY);
}

void mouseReleased() {
  end = new PVector(mouseX, mouseY);
  ball.shoot(start, new PVector(start.x - end.x, start.y - end.y));
}