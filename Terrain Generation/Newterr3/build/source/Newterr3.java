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
float SUN_SPEED      = 0.000f;

// TERRAIN
int T_DIM      = 200;
float T_SIZE   = 5;
float T_AMP    = 160;
float T_RES    = 0.03f;
float T_THRES  = T_AMP * 0.4f;
int   T_SEED   = 123;
int   T_DETAIL = 4;

// WATER
int WATER_TOP = color(81, 215, 239, 200);
int WATER_BTM = color(19, 52, 58, 200);

// TREES
float TREE_RES = 0.01f;

// MODE
// 1 - lateral movement
// 2 - rotational movement
int camera_mode = 1;

// VIEW OFFSET
// float offset_rotation = {-PI / 2, PI, -PI / 2};
float[] offset_rotation = {0, 0, 0};
float[] offset_lateral  = {0, 0, 0};
float offset_scale      = 2;

// for lerping
float[] tgt_offset_rotation = {-PI, PI / 2, 0};
float[] tgt_offset_lateral  = {0, 0, 0};
float tgt_offset_scale      = 1;

// terrain generation offset
float[] offset_terrain = {30000, 30000};

Terrain T = new Terrain(T_DIM);

// Setup function
public void setup() {
  // display settings
  

  // configure lateral offset
  tgt_offset_lateral[0] = width / 2;
  tgt_offset_lateral[1] = height / 2;
  tgt_offset_lateral[2] = 0;

  // random seed
  noiseSeed(T_SEED);
  noiseDetail(T_DETAIL, 0.5f);
  noStroke();

  // initial generation
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
    255,
    220 + 35 * cos(frameCount * SUN_SPEED),
    155 + 100 * cos(frameCount * SUN_SPEED),
    sin(frameCount * SUN_SPEED) * T_SIZE * T_DIM,
    cos(frameCount * SUN_SPEED) * 2 * T_AMP + 2 * T_AMP,
    cos(frameCount * SUN_SPEED) * T_SIZE * T_DIM);
  float ambient = 30 + 150 * cos(frameCount * SUN_SPEED);
  ambientLight(ambient, ambient, ambient);

  // drawing standard unit axis
  // drawAxis();

  // display test terrain
  pushMatrix();
  translate(-T_SIZE * T_DIM / 2, 0, -T_SIZE * T_DIM / 2);

  // draw main terrain
  T.display();
  popMatrix();

  // draw other objects
  // placeSphere(0, 50, 0, 50);
  // drawCylinder(50, 200, 3);

  // draw water
  drawWater(0.95f * T_THRES);

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

    if (key == CODED) {
      switch(keyCode) {
        case UP   : T.moveTerrain(-5, 0); break;
        case DOWN : T.moveTerrain(5, 0); break;
        case LEFT : T.moveTerrain(0, 5); break;
        case RIGHT: T.moveTerrain(0, -5); break;
      }

      // regenerate
      T.generate();
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
public void placeSphere(float x, float y, float z, float radius) {
  pushMatrix();
  translate(x, y, z);
  sphere(radius);
  popMatrix();
}

// draws a cylinder
public void drawCylinder(float radius, float height, int faces) {
  beginShape(QUADS);
  float d = 2 * PI / faces;
  float a_x, a_z, b_x, b_z;
  for (int i = 0; i < faces; i++) {
    a_x = radius * cos(i * d);
    a_z = radius * sin(i * d);
    b_x = radius * cos((i + 1) * d);
    b_z = radius * sin((i + 1) * d);
    vertex(a_x, height, a_z);
    vertex(b_x, height, b_z);
    vertex(b_x, 0, b_z);
    vertex(a_x, 0, a_z);
  }
  endShape(CLOSE);
}

// draws water that has transluscent gradient
public void drawWater(float water_level) {
  pushMatrix();
  translate(-T_SIZE * T_DIM / 2, 0, -T_SIZE * T_DIM / 2);

  beginShape(QUADS);
  fill(WATER_TOP);
  vertex(0, water_level, 0);
  vertex(T_SIZE * T_DIM, water_level, 0);
  vertex(T_SIZE * T_DIM, water_level, T_SIZE * T_DIM);
  vertex(0, water_level, T_SIZE * T_DIM);

  fill(WATER_TOP);
  vertex(0, water_level, 0);
  vertex(T_SIZE * T_DIM, water_level, 0);
  fill(WATER_BTM);
  vertex(T_SIZE * T_DIM, 0, 0);
  vertex(0, 0, 0);

  fill(WATER_TOP);
  vertex(0, water_level, 0);
  vertex(0, water_level, T_SIZE * T_DIM);
  fill(WATER_BTM);
  vertex(0, 0, T_SIZE * T_DIM);
  vertex(0, 0, 0);

  fill(WATER_TOP);
  vertex(T_SIZE * T_DIM, water_level, 0);
  vertex(T_SIZE * T_DIM, water_level, T_SIZE * T_DIM);
  fill(WATER_BTM);
  vertex(T_SIZE * T_DIM, 0, T_SIZE * T_DIM);
  vertex(T_SIZE * T_DIM, 0, 0);

  fill(WATER_TOP);
  vertex(0, water_level, T_SIZE * T_DIM);
  vertex(T_SIZE * T_DIM, water_level, T_SIZE * T_DIM);
  fill(WATER_BTM);
  vertex(T_SIZE * T_DIM, 0, T_SIZE * T_DIM);
  vertex(0, 0, T_SIZE * T_DIM);

  fill(WATER_BTM);
  vertex(0, 0, 0);
  vertex(T_SIZE * T_DIM, 0, 0);
  vertex(T_SIZE * T_DIM, 0, T_SIZE * T_DIM);
  vertex(0, 0, T_SIZE * T_DIM);
  endShape(CLOSE);
  popMatrix();
}
class Terrain {
  private int size;
  private float[] map;
  private Forest forest = new Forest();

  // constructor
  Terrain(int size) {
    this.size = size;
    this.map  = new float[size * size + 1];

    // generate random terrain
    this.generate();
  }

  // Generates random terrain and saves to a map array
  public void generate() {
    // generate terrain mesh
    for (int z = 0; z < this.size; z++) {
      for (int x = 0; x < this.size; x++) {
        this.map[z * this.size + x] = T_AMP * noise(
          (x + offset_terrain[0]) * T_RES, (z + offset_terrain[1]) * T_RES
        );
      }
    }

    // generate forest
    this.forest.generate();
  }

  // returns the height at specific x and z
  private float get(int x, int z) {
    if (x < 0 && z >= 0 && z < this.size)               return get(x + 1, z);
    else if (x >= 0 && z < 0 && z < this.size)          return get(x, z + 1);
    else if (z >= 0 && x >= this.size && z < this.size) return get(x - 1, z);
    else if (x >= 0 && x < this.size && z >= this.size) return get(x, z - 1);
    else if (x < 0 && z < 0)                            return get(0, 0);
    else if (x >= this.size && z >= this.size)          return get(x - 1, z - 1);
    else                                                return map[z * this.size + x];
  }

  private void fillColour(float level) {
    if (level < T_THRES)
      // set water depth color
      fill(lerpColor(
        color(58, 42, 14),
        color(224, 219, 197),
        map(level, T_THRES / 2, T_THRES, 0, 1)
      ));
    else if (level < T_AMP * 0.7f) {
      // land
      fill(lerpColor(
        color(54, 84, 31),
        color(198, 204, 142),
        map(level, T_THRES, T_AMP, 0, 1)
      ));
    }
    else fill(255, 255, 255);
  }

  public void display() {
    float o, a1, a2, d;
    for (int z = 0; z < this.size; z++) {
      for (int x = 0; x < this.size; x++) {
        o  = this.get(x, z);
        a1 = this.get(x + 1, z);
        a2 = this.get(x, z + 1);
        d  = this.get(x + 1, z + 1);

        beginShape(QUADS);
        fillColour(o);
        vertex(x * T_SIZE, o, z * T_SIZE);
        fillColour(a1);
        vertex((x + 1) * T_SIZE, a1, z * T_SIZE);
        fillColour(d);
        vertex((x + 1) * T_SIZE, d, (z + 1) * T_SIZE);
        fillColour(a2);
        vertex(x * T_SIZE, a2, (z + 1) * T_SIZE);
        endShape(CLOSE);
      }
    }

    // draw forest
    this.forest.drawForest(this.map);
  }

  // moves the terrain by offsetting perlin noise
  public void moveTerrain(float dx, float dz) {
    offset_terrain[0] += dx;
    offset_terrain[1] += dz;
  }
}
// basic spherical tree
class Tree {
  private float height;
  private float radius;
  private boolean enabled;

  // constructor
  Tree() {
    // height = random(8) + 5;
    // radius = random(height / 2) + height / 4;
    height = 10;
    radius = 3;
  }

  // draw the tree
  public void drawTree(float x, float y, float z) {
    pushMatrix();
    translate(x, y, z);
    fill(45, 34, 15);
    drawCylinder(1, height, 2);
    translate(0, height, 0);
    fill(0, 50, 0);
    sphere(radius);
    popMatrix();
  }
}

// family of trees
class Forest {
  // generate forest on a separate perlin noise
  private Tree[] trees = new Tree[T_DIM * T_DIM];
  private float[] tree_map = new float[T_DIM * T_DIM];

  Forest() {
    for (int i = 0; i < T_DIM * T_DIM; i++) {
      this.trees[i] = new Tree();
    }

    // initial generation
    this.generate();
  }

  // generate perlin noise for the trees
  public void generate() {
    for (int z = 0; z < T_DIM; z++) {
      for (int x = 0; x < T_DIM; x++) {
        this.tree_map[z * T_DIM + x] = noise((x + offset_terrain[0]) * TREE_RES, (z + offset_terrain[1]) * TREE_RES);
      }
    }
  }

  // draw the trees naturally onto the terrain
  public void drawForest(float[] terrain_map) {
    float level;
    int index;
    for (int z = 0; z < T_DIM; z += 5) {
      for (int x = 0; x < T_DIM; x += 5) {
        index = z * T_DIM + x;
        level = terrain_map[index];
        if (level > T_THRES && level < T_AMP * 0.7f && this.tree_map[index] > 0.6f) {
          trees[index].drawTree(x * T_SIZE, level, z * T_SIZE);
        }
      }
    }
  }
}
  public void settings() {  size(800, 600, P3D); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "--present", "--window-color=#272727", "--stop-color=#cccccc", "Newterr3" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
