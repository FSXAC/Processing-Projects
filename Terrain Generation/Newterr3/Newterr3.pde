// Using 2D perlin noise instead of midpoint displacement

// GLOBAL VARIABLES
Terrain T = new Terrain(10);

// MODE
// 1 - lateral movement
// 2 - rotational movement
int camera_mode = 1;

// VIEW OFFSET
float offset_rotation[] = {-PI / 2, PI, -PI / 2};
float offset_lateral[]  = {width / 2, height / 2, 0};
float offset_scale = 1;

// Setup function
void setup() {
  // display settings
  size(800, 600, P3D);
  noSmooth();

  // light
  // directionalLight(204, 204, 204, 0, 0, -1);

  // initialize terrain
  T.generate();
}

// Main draw loop function
void draw() {
  background(10, 15, 50);

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

  // key hold events
  if (keyPressed) {
    if (camera_mode == 1) {
      switch(key) {
        case 'w': offset_rotation[0] -= 0.1; break;
        case 's': offset_rotation[0] += 0.1; break;
        case 'a': offset_rotation[2] -= 0.1; break;
        case 'd': offset_rotation[2] += 0.1; break;
        case 'r': offset_scale       *= 1.01; break;
        case 'f': offset_scale       *= 0.99; break;
      }
    } else if (camera_mode == 2) {
      // switch(key) {
      //   case 'w':
      // }
    }
  }

  // drawing standard unit axis
  noFill();
  drawAxis();
  pushMatrix();
  translate(0, 0, -5);
  box(500, 500, 10);
  popMatrix();
  pushMatrix();
  translate(0, 0, 50);
  box(50, 20, 100);
  popMatrix();
  pushMatrix();
  translate(0,0,120);
  sphere(20);
  popMatrix();
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
  stroke(255);
}
