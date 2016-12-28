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
// GRAPHICS
float LERP_SPEED     = 0.1f;
float LATERAL_SPEED  = 10;
float ROTATION_SPEED = 0.1f;
float SCALE_SPEED    = 0.03f;

// TERRAIN
int T_DIM    = 100;
float T_SIZE = 5;
float T_AMP  = 200;
float T_RES  = 0.05f;
Terrain T    = new Terrain(T_DIM);

// MODE
// 1 - lateral movement
// 2 - rotational movement
int camera_mode = 1;

// VIEW OFFSET
// float offset_rotation[] = {-PI / 2, PI, -PI / 2};
float offset_rotation[] = {0, 0, 0};
float offset_lateral[]  = {0, 0, 0};
float offset_scale      = 2;

// for lerping
float tgt_offset_rotation[] = {-PI, PI / 2, 0};
float tgt_offset_lateral[]  = {0, 0, 0};
float tgt_offset_scale      = 1;


// Setup function
public void setup() {
  // display settings
  

  // configure lateral offset
  tgt_offset_lateral[0] = width / 2;
  tgt_offset_lateral[1] = height / 2;
  tgt_offset_lateral[2] = 0;

  // initialize terrain
  T.generate();
}

// Main draw loop function
public void draw() {
  // background
  background(230);

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
    sin(frameCount * 0.01f) * T_SIZE * T_DIM,
    cos(frameCount * 0.01f) * 2 * T_AMP + 2 * T_AMP,
    cos(frameCount * 0.01f) * T_SIZE * T_DIM);

  // drawing standard unit axis
  // noFill();
  fill(255);
  drawAxis();

  noStroke();
  // pushMatrix();
  // translate(0, -10, 0);
  // box(200, 20, 200);
  // popMatrix();
  // placeSphere(0, 0, 30);
  // placeSphere(20, 20, 10);
  // placeSphere(-110, 25, 100);

  // display test terrain
  pushMatrix();
  translate(-T_SIZE * T_DIM / 2, 0, -T_SIZE * T_DIM / 2);
  T.display();
  popMatrix();

  // key hold events
  checkKeyInput();

  // updating lerp animations
  lerpUpdateCamera();
}

// check for using command inputs and execute
public void checkKeyInput() {
  if (keyPressed) {
    if (camera_mode == 1) {
      switch(key) {
        case 'w': tgt_offset_rotation[0] -= ROTATION_SPEED; break;
        case 's': tgt_offset_rotation[0] += ROTATION_SPEED; break;
        case 'a': tgt_offset_rotation[1] -= ROTATION_SPEED; break;
        case 'd': tgt_offset_rotation[1] += ROTATION_SPEED; break;
        case 'r': tgt_offset_scale       *= 1 + SCALE_SPEED; break;
        case 'f': tgt_offset_scale       *= 1 - SCALE_SPEED; break;
      }

    } else if (camera_mode == 2) {
      switch(key) {
        case 'w': tgt_offset_lateral[2] += LATERAL_SPEED; break;
        case 's': tgt_offset_lateral[2] -= LATERAL_SPEED; break;
        case 'a': tgt_offset_lateral[0] += LATERAL_SPEED; break;
        case 'd': tgt_offset_lateral[0] -= LATERAL_SPEED; break;
        case 'r': tgt_offset_lateral[1] += LATERAL_SPEED; break;
        case 'f': tgt_offset_lateral[1] -= LATERAL_SPEED; break;
      }
    }
  }
}

// updating current camera to lerp to target camera
public void lerpUpdateCamera() {
  for (int i = 0; i < 3; i++) {
    offset_lateral[i]  = lerp(offset_lateral[i], tgt_offset_lateral[i], LERP_SPEED);
    offset_rotation[i] = lerp(offset_rotation[i], tgt_offset_rotation[i], LERP_SPEED);
  }
  offset_scale = lerp(offset_scale, tgt_offset_scale, LERP_SPEED);
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

// PLACING OBJECTS INTO ENVIRONMENT FUNCTIONS
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
        this.map[y * this.size + x] = T_AMP * noise(x * T_RES, y * T_RES);
      }
    }
  }

  // returns the height at specific x and y
  private float get(int x, int y) {
    // if (x < 0 || y < 0)                        return get(x + 1, y + 1);
    // else if (x >= this.size || y >= this.size) return get(x - 1, y - 1);
    // else                                       return map[y * size + x];
    if (x < 0 && y >= 0 && y < this.size)               return get(x + 1, y);
    else if (x >= 0 && y < 0 && x < this.size)          return get(x, y + 1);
    else if (y >= 0 && x >= this.size && y < this.size) return get(x - 1, y);
    else if (x >= 0 && x < this.size && y >= this.size) return get(x, y - 1);
    else if (x < 0 && y < 0)                            return get(0, 0);
    else if (x >= this.size && y >= this.size)          return get(x - 1, y - 1);
    else                                                return map[y * size + x];
  }

  public void display() {
    for (int y = 0; y < this.size; y++) {
      for (int x = 0; x < this.size; x++) {
        // draw triangle and verticies
        beginShape(TRIANGLE_FAN);
        vertex(x * T_SIZE,       this.get(x, y),     y * T_SIZE);
        vertex((x + 1) * T_SIZE, this.get(x + 1, y), y * T_SIZE);
        vertex(x * T_SIZE,       this.get(x, y + 1), (y + 1) * T_SIZE);
        endShape(CLOSE);

        // second half of the triangle
        beginShape(TRIANGLE_FAN);
        vertex((x + 1) * T_SIZE, get(x + 1, y),     y * T_SIZE);
        vertex(x * T_SIZE,       get(x, y + 1),     (y + 1) * T_SIZE);
        vertex((x + 1) * T_SIZE, get(x + 1, y + 1), (y + 1) * T_SIZE);
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
