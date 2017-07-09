PShape can;
float angle;
PShader colorShader;

void setup() {
    size(800, 600, P3D);
    can = createCan(100, 200, 32);
    
    // shader
    colorShader = loadShader("colorFrag.glsl", "colorVert.glsl");
}

void draw() {
    background(0);
    shader(colorShader);
    translate(width / 2, height / 2);
    rotateY(angle);
    rotateX(map(mouseY, 0, height, -PI/2, PI/2));
    shape(can);
    angle += 0.03;
}

PShape createCan(float r, float h, int detail) {
    textureMode(NORMAL);
    PShape shape = createShape();
    shape.beginShape(QUAD_STRIP);
    shape.fill(255, 0, 0);
    shape.noStroke();
    
    for (int i = 0; i <= detail; i++) {
        float angleStep = TWO_PI / detail;
        float x = sin(i * angleStep);
        float z = cos(i * angleStep);
        float u = float(i) / detail;
        shape.normal(x, 0, z);
        shape.vertex(x * r, -h/2, z * r, u, 0);
        shape.vertex(x * r, h/2, z * r, u, 1);
    }
    
    shape.endShape();
    return shape;
}