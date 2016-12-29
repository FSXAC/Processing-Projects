// Using 2D perlin noise instead of midpoint displacement

// GLOBAL VARIABLES
// GRAPHICS
float LERP_SPEED     = 0.1;
float LATERAL_SPEED  = 10;
float ROTATION_SPEED = 0.1;
float SCALE_SPEED    = 0.03;
float SUN_SPEED      = 0.000;

// TERRAIN
int T_DIM       = 200;
float T_SIZE    = 5;
float T_AMP     = 160;
float T_RES     = 0.03;
float T_THRES   = T_AMP * 0.4;
int   T_SEED    = 123;
int   T_DETAIL  = 4;
Terrain T       = new Terrain(T_DIM);

// WATER
color WATER_TOP = color(81, 215, 239, 200);
color WATER_BTM = color(19, 52, 58, 200);

// TREES
float TREE_RES = 0.01;

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


// Setup function
void setup() {
  // display settings
  size(800, 600, P3D);

  // configure lateral offset
  tgt_offset_lateral[0] = width / 2;
  tgt_offset_lateral[1] = height / 2;
  tgt_offset_lateral[2] = 0;

  // random seed
  noiseSeed(T_SEED);
  noiseDetail(T_DETAIL, 0.5);
  noStroke();

  // initial generation
  T.generate();
}

// Main draw loop function
void draw() {
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
  drawWater(0.95 * T_THRES);

  // key hold events
  checkKeyInput();

  // updating lerp animations
  lerpUpdateCamera();
}

// check for using command inputs and execute
void checkKeyInput() {
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
void lerpUpdateCamera() {
  for (int i = 0; i < 3; i++) {
    offset_lateral[i]  = lerp(offset_lateral[i], tgt_offset_lateral[i], LERP_SPEED);
    offset_rotation[i] = lerp(offset_rotation[i], tgt_offset_rotation[i], LERP_SPEED);
  }
  offset_scale = lerp(offset_scale, tgt_offset_scale, LERP_SPEED);
}

// keyboard events
void keyPressed() {
  switch(key) {
    // changing modes
    case '1': camera_mode = 1; break;
    case '2': camera_mode = 2; break;
    default: break;
  }
}

// PLACING OBJECTS INTO ENVIRONMENT FUNCTIONS
// Draws the unit vectors
void drawAxis() {
  stroke(255, 0, 0);
  line(0, 0, 0, 100, 0, 0);
  stroke(0, 255, 0);
  line(0, 0, 0, 0, 100, 0);
  stroke(0, 0, 255);
  line(0, 0, 0, 0, 0, 100);
}

// place a sphere on the surface where y = 0
void placeSphere(float x, float y, float z, float radius) {
  pushMatrix();
  translate(x, y, z);
  sphere(radius);
  popMatrix();
}

// draws a cylinder
void drawCylinder(float radius, float height, int faces) {
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
void drawWater(float water_level) {
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
