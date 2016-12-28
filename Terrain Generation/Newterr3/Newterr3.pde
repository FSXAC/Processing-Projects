// Using 2D perlin noise instead of midpoint displacement

// GLOBAL VARIABLES
// GRAPHICS
float LERP_SPEED     = 0.1;
float LATERAL_SPEED  = 10;
float ROTATION_SPEED = 0.1;
float SCALE_SPEED    = 0.03;
float SUN_SPEED      = 0.005;

// TERRAIN
int T_DIM     = 100;
float T_SIZE  = 5;
float T_AMP   = 200;
float T_RES   = 0.03;
float T_THRES = T_AMP * 0.4;
Terrain T     = new Terrain(T_DIM);

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
void setup() {
  // display settings
  size(800, 600, P3D);

  // configure lateral offset
  tgt_offset_lateral[0] = width / 2;
  tgt_offset_lateral[1] = height / 2;
  tgt_offset_lateral[2] = 0;

  // random seed
  noiseSeed(123);
  noiseDetail(3);

  // initialize terrain
  T.generate();
  noStroke();
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

  // drawing standard unit axis
  // drawAxis();

  // display test terrain
  pushMatrix();
  translate(-T_SIZE * T_DIM / 2, 0, -T_SIZE * T_DIM / 2);

  // draw main terrain
  T.display();
  popMatrix();

  // draw water
  pushMatrix();
  fill(59, 170, 175, 100);
  translate(0, 5 * T_THRES / 12, 0);
  box(T_SIZE * T_DIM, 5 * T_THRES / 6, T_SIZE * T_DIM);

  translate(0, 4 * T_THRES / 12, 0);
  box(T_SIZE * T_DIM, 4 * T_THRES / 6, T_SIZE * T_DIM);

  translate(0, 3 * T_THRES / 12, 0);
  box(T_SIZE * T_DIM, 3 * T_THRES / 6, T_SIZE * T_DIM);

  translate(0, 2 * T_THRES / 12, 0);
  box(T_SIZE * T_DIM, 2 * T_THRES / 6, T_SIZE * T_DIM);

  translate(0, 1 * T_THRES / 12, 0);
  box(T_SIZE * T_DIM, 1 * T_THRES / 6, T_SIZE * T_DIM);

  popMatrix();

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
void placeSphere(float x, float z, float radius) {
  pushMatrix();
  translate(x, radius, z);
  sphere(radius);
  popMatrix();
}

// draws water that has transluscent gradient
