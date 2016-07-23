/**
 * Bouncing Ball Program
 * Similar to the Python version made back in 2014
 *
 * by Mooch
 */

// constants
int ENTITY_LIMIT = 500;

// global vars
int count = 0;
int time = 0;
int ptime;

// simulation parameres
int gravity_interval = 2;
float gravity = 0;
boolean collide = true;
boolean warpBoundaries = true;

// object arrays
Ball[] balls = new Ball[ENTITY_LIMIT];

void setup() {
  // setup window size
  size(1600, 900, P2D);
  
  // setup background;
  background(0);
  
  // setup drawing
  noStroke();
}

void draw() {
  if (mousePressed && count < ENTITY_LIMIT) {
    balls[count] = new Ball(mouseX, mouseY);
    count++;
  }
  
  // clear screen
  background(0);
  fill(0, 10);
  
  // draw balls
  for (int i = 0; i < count; i++) {
     balls[i].drawBall();
     balls[i].update();
     
     for (int j = 0; j < count; j++) {
       if (j != i && collide) {
         balls[i].checkCollision(balls[j]);
       }
     }
  }
  
  // switch gravity
  ptime = time;
  time = int(millis() / 1000) % gravity_interval;
  
  if (ptime != time && time == 0) {
    println("gravity flipped");
    gravity *= -1;
  }
}

//void mousePressed() {
//  if (count < ENTITY_LIMIT) {
//    balls[count] = new Ball(mouseX, mouseY);
//    count++;
//  }
//}