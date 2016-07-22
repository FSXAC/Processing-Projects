class Ball {
  PVector position, velocity;
  float radius, mass;
  int color_R, color_G, color_B;
  float elsticity = random(-0.8, -0.1);
  
  Ball(float x, float y) {
    position = new PVector(x, y);
    velocity = new PVector(random(-5, 5), random(-5, 5));
    radius = int(random(2, 20));
    mass = radius * 0.2;
    color_R = int(random(0, 50));
    color_G = int(random(50, 255));
    color_B = int(random(0, 50));
  }
  
  void drawBall() {
    noStroke();
    if (velocity.y > 0) {
      fill(color_R, color_G, color_B);
    } else {
      fill(color_B, color_R, color_G);
    }
    
    ellipse(position.x, position.y, radius, radius);
  }
  
  void update(float acceleration) {
    // update velocity
    velocity.y += acceleration;
    
    // update position
    position.x += velocity.x;
    position.y += velocity.y;
    
    // check boundary collision
    if (position.x >= width) {
      velocity.x *= -1;
      position.x = width - radius;
    }
    if (position.x <= 0) {
      velocity.x *= -1;
      position.x = radius;
    }
    if (position.y >= height) {
      velocity.y *= elsticity;
      position.y = height - radius;
    }
    if (position.y <= 0) {
      velocity.y *= elsticity;
      position.y = 0 + radius;
    } 
  }
  
  void checkCollision(Ball other) {

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
}