// Using 2D perlin noise instead of midpoint displacement

// GLOBAL VARIABLES
Terrain T = new Terrain(10);

// MODE
// 1 - lateral movement
// 2 - rotational movement
int camera_mode = 1;

// VIEW OFFSET
float offset_rotation[] = {0, 0};
float offset_lateral[]  = {width / 2, height / 2, 0};
float offset_scale = 1;

// Setup function
void setup() {
  // display settings
  size(800, 600, P3D);

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

  // scale
  scale(offset_scale);

  // key hold events
  if (keyPressed) {
    switch(key) {
      case 'w': offset_rotation[0] -= 0.1; break;
      case 's': offset_rotation[0] += 0.1; break;
      case 'a': offset_rotation[1] += 0.1; break;
      case 'd': offset_rotation[1] -= 0.1; break;
      case 'r': offset_scale       *= 1.02; break;
      case 'f': offset_scale       *= 0.98; break;
    }
  }

  // drawing
  box(200);
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
