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

// global variables
Terrain T = new Terrain(10);

// mode:
// 0 - orbit mode
int camera_mode = 1;

// Setup function
public void setup() {
  // display settings
  

  // light
  directionalLight(204, 204, 204, 0, 0, -1);

  // initialize terrain
  T.generate();
}

// Main draw loop function
public void draw() {
  background(10, 15, 50);

  // view controls
  // lateral
  translate(width / 2, height / 2, 0);
  rotateY(map(mouseX, 0, width, 0, 10));
  rotateX(map(mouseY, 0, width, 0, 10));

  // drawing
  box(200);
}

// keyboard events
public void keyPressed() {
  switch(key) {
    case '1': camera_mode = 1; break;
    case '2': camera_mode = 2; break;
    default: break;
  }
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
  public void settings() {  size(1280, 720, P3D); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "Newterr3" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
