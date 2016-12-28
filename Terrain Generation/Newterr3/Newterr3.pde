// Using 2D perlin noise instead of midpoint displacement

// global variables
Terrain T = new Terrain(10);

// mode:
// 1 - lateral movement
// 2 - rotational movement
int camera_mode = 1;

// VIEW OFFSET
float offset_rotation[] = {0, 0, 0};
float offset_lateral[] = {width / 2, height / 2, 0};

// Setup function
void setup() {
  // display settings
  size(1280, 720, P3D);

  // light
  directionalLight(204, 204, 204, 0, 0, -1);

  // initialize terrain
  T.generate();
}

// Main draw loop function
void draw() {
  background(10, 15, 50);

  // view controls
  // lateral
  translate(offset_lateral[0],
            offset_lateral[1],
            offset_lateral[2]);
  // rotational
  rotate(offset_rotation[0],
         offset_rotation[1],
         offset_rotation[2])

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

  if (camera_mode == 1) {
    switch(key) {
      case 'w':
        offset_lateral[0] += 
    }
  }
}
