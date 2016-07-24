// Catepault mouse guesture test

int MAX_ENTITY = 500;
Ball ball;

// vector calculation
PVector start, current, projection, end;

void setup() {
  stroke(150);
  strokeWeight(4);
  size(800, 800);
  
  ball = new Ball(new PVector(width / 2, height / 2), new PVector(0, 0));
  projection = new PVector(0, 0);
}

void draw() {
  background(0);
  ball.display();
  
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
  ball.position = start;
  ball.velocity.x = start.x - end.x;
  ball.velocity.y = start.y - end.y;
  ball.velocity.mult(0.05);
}

class Ball {
  PVector position, velocity;
  Ball(PVector pos, PVector vel) {
    position = pos;
    velocity = vel;
  }
  
  void display() {
    fill(255);
    ellipse(position.x, position.y, 20, 20);
    position.add(velocity);
  }
}