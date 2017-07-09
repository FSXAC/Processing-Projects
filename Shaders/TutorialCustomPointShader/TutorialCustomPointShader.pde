PShader pointShader;
PImage smoke;

float weight = 100;

void setup() {
    size(800, 600, P3D);
    pointShader = loadShader("smokeFrag.glsl", "smokeVert.glsl");
    
    // this sets the uniform
    pointShader.set("weight", weight);
    
    smoke = loadImage("smoke.png");
    pointShader.set("smoke", smoke);
    
    strokeWeight(weight);
    strokeCap(SQUARE);
    stroke(255, 70);
    
    background(0);
}

void draw() {
    
    // custom points shader
    shader(pointShader, POINTS);
    
    if (mousePressed) {
        point(mouseX, mouseY);
    }
}