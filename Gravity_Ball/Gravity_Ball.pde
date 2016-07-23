/* Newtonian Gravity Program
 *
 */

// constatns
int MAX_ENTITY = 500;

// global vars
int count = 0;

// object array
Ball[] balls = new Ball[MAX_ENTITY];

void setup() {
  size(1600, 900, P2D);
  
  // background
  background(0);
  
  // setup drawing
  noStroke();
}

void draw() {
  // clear screen
  background(0);
  
  for (int i = 0; i < count; i++) {
    balls[i].drawBall();
    balls[i].update();
    
    // acceleration due to gravity
    for (int j = 0; j < count; j++) {
      if (i != j) {
        balls[i].gravitate(balls[j]);
      }
    }
  }
}

void mousePressed() {
  if (count < MAX_ENTITY) {
    balls[count] = new Ball(mouseX, mouseY);
    
    if (count == 0) {
      //balls[count].setFixed();
    }
    count++;
  }
}