import peasy.PeasyCam;

PeasyCam cam;

void setup() {
  size(800, 600, P3D);
  cam = new PeasyCam(this, 400);
  background(255);
}

void draw() {
  background(255);
  lights();
  
  pushMatrix();
  
  fill(120, 160, 200);
  shininess(50);
  sphere(100);
  
  noStroke();
  fill(200, 180, 120);
  shininess(1);
  drawTerrain();
  
  popMatrix();
}

void drawTerrain() {
  float radius = 100;
  int detailLong = 50;
  int detailLat = 50;
  
  for (int iLat = 0; iLat <= detailLat; iLat++) {
    beginShape(TRIANGLE_STRIP);
    for (int iLong = 0; iLong <= detailLong; iLong++) {
      float r = radius;
      float t = (iLong)* PI / detailLong;
      float p = (iLat) * 2 *PI / detailLat;
      
      r = r + 10 * (noise(t, p) - 0.5);
      PVector location = sphericalToCartesian(r, t, p);
      PVector neighbour = sphericalToCartesian(r, t, (iLat + 1) * 2 * PI / detailLat);
      
      vertex(location.x, location.y, location.z);
      vertex(neighbour.x, neighbour.y, neighbour.z);
    }
    endShape(CLOSE);
  }
}

PVector sphericalToCartesian(float r, float t, float p) {
  PVector a = new PVector();
  a.x = r * sin(t) * cos(p);
  a.y = r * sin(t) * sin(p);
  a.z = r * cos(t);
  return a;
}
