import peasy.*;

PeasyCam cam;

// convention:
// xz plane: ground plane
// y: height

// facts:
// course dimension is 2134mm in sidelength

final int COURSE_SIZE = 21;
// final int COURSE_SIZE = 2134;

void setup() {
    size(1280, 800, P3D);
    frameRate(60);

    // camera
    cam = new PeasyCam(this, 100);
    cam.setMinimumDistance(50);
    cam.setMaximumDistance(500);
    cam.setSuppressRollRotationMode();
}

void draw() {
    background(0);
    drawGround();
}

void drawGround() {
    rectMode(CENTER);
    rect(0, 0, 2134, 2134);
}