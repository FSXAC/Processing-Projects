// Using 2D perlin noise instead of midpoint displacement

// global variables
Terrain T;

// Setup function
void setup() {
  // display settings
  size(1280, 720, P3D);
  noStroke();
  smooth();
  
  // initialize terrain
  T.generate();
}

// Main draw loop function
void draw() {
  scale(map(mouseY, 0, height, 15, 1));
  T.display();
}