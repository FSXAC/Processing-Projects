PShape can;
float angle;
PShader lightShader;
PImage canTexture;

void setup() {
    size(800, 600, P3D);
    canTexture = loadImage("image.jpg");
    can = createCan(100, 200, 32, canTexture);
    
    // shader
    lightShader = loadShader("lightFrag.glsl", "lightVert.glsl");
}

void draw() {
    background(0);
    shader(lightShader);
    //pointLight(255, 255, 255, width/2, height, 200);
    directionalLight(255, 255, 255, -1, -1, -1);
    translate(width / 2, height / 2);
    rotateY(angle);
    rotateX(map(mouseY, 0, height, -PI/2, PI/2));
    shape(can);
    angle += 0.03;
}

PShape createCan(float r, float h, int detail, PImage texture) {
    textureMode(NORMAL);
    PShape shape = createShape();
    shape.beginShape(QUAD_STRIP);
    shape.noStroke();
    shape.texture(texture);
    
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