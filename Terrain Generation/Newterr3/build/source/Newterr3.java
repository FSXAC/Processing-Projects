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

public class Newterr3 extends PApplet {

// Using 2D perlin noise instead of midpoint displacement

// GLOBAL VARIABLES
Terrain T = new Terrain(10);

// MODE
// 1 - lateral movement
// 2 - rotational movement
int camera_mode = 1;

// VIEW OFFSET
// float offset_rotation[] = {-PI / 2, PI, -PI / 2};
float offset_rotation[] = {-PI, PI / 2, 0};
float offset_lateral[] = {0, 0, 0};
float offset_scale = 1;

// Setup function
public void setup() {
  // display settings
  

  // configure lateral offset
  offset_lateral[0] = width / 2;
  offset_lateral[1] = height / 2;
  offset_lateral[2] = 0;

  // initialize terrain
  T.generate();
}

// Main draw loop function
public void draw() {
  // background
  background(10, 15, 50);

  // CAMERA
  // ortho();

  // view controls
  // lateral
  translate(offset_lateral[0],
            offset_lateral[1],
            offset_lateral[2]);

  // rotational
  rotateX(offset_rotation[0]);
  rotateY(offset_rotation[1]);
  rotateZ(offset_rotation[2]);

  // scale
  scale(offset_scale);

  // LIGHTING
  pointLight(
    255, 255, 255,
    sin(frameCount * 0.01f) * 80,
    cos(frameCount * 0.01f) * 50 + 50,
    cos(frameCount * 0.01f) * 200);

  // drawing standard unit axis
  // noFill();
  fill(255);
  drawAxis();

  noStroke();
  pushMatrix();
  translate(0, -10, 0);
  box(200, 20, 200);
  popMatrix();
  placeSphere(0, 0, 30);
  placeSphere(20, 20, 10);
  placeSphere(-110, 25, 100);

  // key hold events
  if (keyPressed) {
    if (camera_mode == 1) {
      switch(key) {
        case 'w': offset_rotation[0] -= 0.1f; break;
        case 's': offset_rotation[0] += 0.1f; break;
        case 'a': offset_rotation[1] -= 0.1f; break;
        case 'd': offset_rotation[1] += 0.1f; break;
        case 'r': offset_scale       *= 1.03f; break;
        case 'f': offset_scale       *= 0.97f; break;
      }
    } else if (camera_mode == 2) {
      switch(key) {
        case 'w': offset_lateral[2] += 3; break; // FIXME
        case 's': offset_lateral[2] -= 3; break;
        case 'a': offset_lateral[0] += 3; break;
        case 'd': offset_lateral[0] -= 3; break;
      }
    }
  }
}

// keyboard events
public void keyPressed() {
  switch(key) {
    // changing modes
    case '1': camera_mode = 1; break;
    case '2': camera_mode = 2; break;
    default: break;
  }
}

// Draws the unit vectors
public void drawAxis() {
  stroke(255, 0, 0);
  line(0, 0, 0, 100, 0, 0);
  stroke(0, 255, 0);
  line(0, 0, 0, 0, 100, 0);
  stroke(0, 0, 255);
  line(0, 0, 0, 0, 0, 100);
}

// place a sphere on the surface where y = 0
public void placeSphere(float x, float z, float radius) {
  pushMatrix();
  translate(x, radius, z);
  sphere(radius);
  popMatrix();
}
class Terrain {
  private int size;
  private float[] map;

  // constructor
  Terrain(int size) {
    this.size = size;
    this.map  = new float[size * size + 1];

    // generate random terrain
    this.generate();
  }

  // Generates random terrain and saves to a map array
  public void generate() {
    for (int y = 0; y < this.size; y++) {
      for (int x = 0; x < this.size; x++) {
        this.map[y * this.size + x] = 10 * noise(x, y);
      }
    }
  }

  // *** GETTERS and SETTERS
  private float get(int x, int y) {
    if (x < 0 || y < 0 || x >= this.size || y >= this.size) return -1;
    else return map[y * size + x];
  }

  public void display() {
    for (int y = 0; y < this.size; y++) {
      for (int x = 0; x < this.size; x++) {
        // draw triangle and verticies
        beginShape(TRIANGLE_FAN);
        vertex(x, y, this.get(x, y));
        vertex(x + 1, y, this.get(x + 1, y));
        vertex(x, y + 1, this.get(x, y + 1));
        endShape(CLOSE);

        // second half of the triangle
        beginShape(TRIANGLE_FAN);
        vertex(x + 1, y, get(x + 1, y));
        vertex(x, y + 1, get(x, y + 1));
        vertex(x + 1, y + 1, get(x + 1, y + 1));
        endShape(CLOSE);
      }
    }
  }
}
  public void settings() {  size(800, 600, P3D); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "Newterr3" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
