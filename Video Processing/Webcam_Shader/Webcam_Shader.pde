import processing.video.*;

Capture video;
PShader toon;

void setup() {
  size(640, 480, P3D);
  String[] cameras = Capture.list();
   
  if (cameras.length != 0)
  printArray(cameras);
 
  video = new Capture(this, 640, 480, 30);
  video.start();
  toon = loadShader("ToonFrag.glsl", "ToonVert.glsl");
}

void captureEvent(Capture video) {
  video.read();
}

void draw() {
  image(video, 0, 0);
  shader(toon);
  noStroke(); 
  //background(0); 
  float dirY = (mouseY / float(height) - 0.5) * 2;
  float dirX = (mouseX / float(width) - 0.5) * 2;
  directionalLight(204, 204, 204, -dirX, -dirY, -1);
  translate(width/2, height/2);
  sphere(120);
}