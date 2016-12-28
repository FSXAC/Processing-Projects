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
float offset_lateral[]  = {width / 2, height / 2, 0};
float offset_scale = 1;

// Setup function
void setup() {
  // display settings
  size(800, 600, P3D);

  // initialize terrain
  T.generate();
}

// Main draw loop function
void draw() {
  // background
  background(10, 15, 50);

  // CAMERA
  // ortho();

  // view controls
  // lateral
  // translate(offset_lateral[0],
  //           offset_lateral[1],
  //           offset_lateral[2]);
  translate(width / 2, height / 2, 0);

  // rotational
  rotateX(offset_rotation[0]);
  rotateY(offset_rotation[1]);
  rotateZ(offset_rotation[2]);

  // scale
  scale(offset_scale);

  // LIGHTING
  pointLight(
    255, 255, 255,
    sin(frameCount * 0.01) * 80,
    sin(frameCount * 0.01) * 50 + 50,
    cos(frameCount * 0.01) * 200);

  // drawing standard unit axis
  // noFill();
  fill(255);
  drawAxis();

  noStroke();
  pushMatrix();
  translate(0, -5, 0);
  box(100, 10, 100);
  popMatrix();
  placeSphere(0, 0, 10);

  // key hold events
  if (keyPressed) {
    if (camera_mode == 1) {
      switch(key) {
        case 'w': offset_rotation[0] -= 0.1; break;
        case 's': offset_rotation[0] += 0.1; break;
        case 'a': offset_rotation[1] -= 0.1; break;
        case 'd': offset_rotation[1] += 0.1; break;
        case 'r': offset_scale       *= 1.03; break;
        case 'f': offset_scale       *= 0.97; break;
      }
    } else if (camera_mode == 2) {
      switch(key) {
        // case 'w': offset_lateral[0] +=
      }
    }
  }
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
