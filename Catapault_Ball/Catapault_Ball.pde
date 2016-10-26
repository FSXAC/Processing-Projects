// Catepault mouse guesture test

int MAX_ENTITY = 500;

Ball[] balls = new Ball[MAX_ENTITY];

// physics constants
float SPEED_FACTOR = 0.1;
float FRICTION = 0.00001;

// vector calculation
PVector start, current, projection, end;
int count = 0;

void setup() {
  stroke(150);
  strokeWeight(1);
  size(800, 800);

  projection = new PVector(0, 0);
}

void draw() {
  background(0);

  for (int i = 0; i < count; i++) {
    balls[i].display();
    balls[i].update();

    for (int j = 0; j < count; j++) {
      if (i != j) {
        balls[i].checkCollision(balls[j]);
      }
    }
  }

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
  balls[count] = new Ball();
  balls[count].shoot(start, new PVector(start.x - end.x, start.y - end.y));
  count++;
}

void keyPressed() {
  // setup triangle form
  for (int i = 0; i < 5; i++) {
    for (int j = 0; j <= i; j++) {
      balls[count] = new Ball();
      balls[count].position.x = 100 + 24 * i - 12*j;
      balls[count].position.y = 200 + 24 * j;
      count++;
    }
  }
}
