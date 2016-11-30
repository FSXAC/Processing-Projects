import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class Catapault_Ball extends PApplet {

// Catepault mouse guesture test

int MAX_ENTITY = 500;

Ball[] balls = new Ball[MAX_ENTITY];

// physics constants
float SPEED_FACTOR = 0.1f;
float FRICTION = 0.00001f;

// vector calculation
PVector start, current, projection, end;
int count = 0;

public void setup() {
  stroke(150);
  strokeWeight(1);
  
  

  projection = new PVector(0, 0);
}

public void draw() {
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

public void mousePressed() {
  start = new PVector(mouseX, mouseY);
}

public void mouseReleased() {
  end = new PVector(mouseX, mouseY);
  balls[count] = new Ball();
  balls[count].shoot(start, new PVector(start.x - end.x, start.y - end.y));
  count++;
}

public void keyPressed() {
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
class Ball {
  // properties
  PVector position, velocity;
  int radius = 10;
  int mass = radius;
  float speedMulti = 1;
  int fillColor = color(PApplet.parseInt(random(0, 255)), PApplet.parseInt(random(0, 255)), PApplet.parseInt(random(0, 255)));
  
  // constructor
  Ball() {
    position = new PVector(0, 0);
    velocity = new PVector(0, 0);
  }
  
  public void display() {
    fill(fillColor);
    ellipse(position.x, position.y, radius * 2, radius * 2);
  }
  
  public void update() {
    // move
    position.add(velocity);
    
    // change speed
    if (speedMulti > 0) {
      speedMulti -= FRICTION;
    }
    
    // reset friction after stopping
    if (velocity.mag() < FRICTION) {
      velocity.x = 0;
      velocity.y = 0;
      speedMulti = 1;
    }
    
    // update speed
    velocity.mult(speedMulti);

    // check boundary collision
    if (position.x > width - radius) {
      velocity.x *= -1;
      position.x = width - radius;
    }
    else if (position.x < radius) {
      velocity.x *= -1;
      position.x = radius;
    }
    if (position.y > height - radius) {
      velocity.y *= -1;
      position.y = height - radius;
    }
    else if (position.y < radius) {
      velocity.y *= -1;
      position.y = radius;
    }
  }
  
  public void checkCollision(Ball other) {

    // get distances between the balls components
    PVector bVect = PVector.sub(other.position, position);

    // calculate magnitude of the vector separating the balls
    float bVectMag = bVect.mag();

    if (bVectMag < radius + other.radius) {
      // get angle of bVect
      float theta  = bVect.heading();
      // precalculate trig values
      float sine = sin(theta);
      float cosine = cos(theta);

      /* bTemp will hold rotated ball positions. You 
       just need to worry about bTemp[1] position*/
      PVector[] bTemp = {
        new PVector(), new PVector()
      };

      /* this ball's position is relative to the other
       so you can use the vector between them (bVect) as the 
       reference point in the rotation expressions.
       bTemp[0].position.x and bTemp[0].position.y will initialize
       automatically to 0.0, which is what you want
       since b[1] will rotate around b[0] */
      bTemp[1].x  = cosine * bVect.x + sine * bVect.y;
      bTemp[1].y  = cosine * bVect.y - sine * bVect.x;

      // rotate Temporary velocities
      PVector[] vTemp = {
        new PVector(), new PVector()
      };

      vTemp[0].x  = cosine * velocity.x + sine * velocity.y;
      vTemp[0].y  = cosine * velocity.y - sine * velocity.x;
      vTemp[1].x  = cosine * other.velocity.x + sine * other.velocity.y;
      vTemp[1].y  = cosine * other.velocity.y - sine * other.velocity.x;

      /* Now that velocities are rotated, you can use 1D
       conservation of momentum equations to calculate 
       the final velocity along the x-axis. */
      PVector[] vFinal = {  
        new PVector(), new PVector()
        };

      // final rotated velocity for b[0]
      vFinal[0].x = ((mass - other.mass) * vTemp[0].x + 2 * other.mass * vTemp[1].x) / (mass + other.mass);
      vFinal[0].y = vTemp[0].y;

      // final rotated velocity for b[0]
      vFinal[1].x = ((other.mass - mass) * vTemp[1].x + 2 * mass * vTemp[0].x) / (mass + other.mass);
      vFinal[1].y = vTemp[1].y;

      // hack to avoid clumping
      bTemp[0].x += vFinal[0].x;
      bTemp[1].x += vFinal[1].x;

      /* Rotate ball positions and velocities back
       Reverse signs in trig expressions to rotate 
       in the opposite direction */
      // rotate balls
      PVector[] bFinal = { 
        new PVector(), new PVector()
        };

      bFinal[0].x = cosine * bTemp[0].x - sine * bTemp[0].y;
      bFinal[0].y = cosine * bTemp[0].y + sine * bTemp[0].x;
      bFinal[1].x = cosine * bTemp[1].x - sine * bTemp[1].y;
      bFinal[1].y = cosine * bTemp[1].y + sine * bTemp[1].x;

      // update balls to screen position
      other.position.x = position.x + bFinal[1].x;
      other.position.y = position.y + bFinal[1].y;

      position.add(bFinal[0]);

      // update velocities
      velocity.x = cosine * vFinal[0].x - sine * vFinal[0].y;
      velocity.y = cosine * vFinal[0].y + sine * vFinal[0].x;
      other.velocity.x = cosine * vFinal[1].x - sine * vFinal[1].y;
      other.velocity.y = cosine * vFinal[1].y + sine * vFinal[1].x;
    }
  }
  
  public void shoot(PVector pos, PVector vel) {
    speedMulti = 1;
    position = pos;
    velocity = vel;
    velocity.mult(SPEED_FACTOR);
  }
}
  public void settings() {  size(800, 800);  pixelDensity(2); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "--present", "--window-color=#272727", "--stop-color=#cccccc", "Catapault_Ball" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
