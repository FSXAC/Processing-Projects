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
float gravity = 0.5;

boolean collide = false;

Ball[] balls = new Ball[ENTITY_LIMIT];

// object arrays
void setup() {
  // setup window size
  size(1000, 800);
  
  // setup background;
  background(0);
}

void draw() {
  if (mousePressed && count < ENTITY_LIMIT) {
    balls[count] = new Ball(mouseX, mouseY);
    count++;
  }
  
  // clear screen
  background(0);
  
  // draw balls
  for (int i = 0; i < count; i++) {
     balls[i].drawBall();
     balls[i].update(gravity);
     for (int j = 0; j < count; j++) {
       if (j != i && collide) {
         balls[i].checkCollision(balls[j]);
       }
     }
  }
  
  // switch gravity
  ptime = time;
  time = int(millis() / 1000) % 5;
  
  if (ptime != time && time == 0) {
    println("gravity flipped");
    gravity *= -1;
  }
}