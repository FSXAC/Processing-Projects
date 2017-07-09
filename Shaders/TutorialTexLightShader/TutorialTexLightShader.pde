PImage canTexture;
PShape can;
float angle;

PShader texlightShader;

void setup() {
    size(800, 600, P3D);
    canTexture = loadImage("image.jpg");
    can = createCan(100, 200, 32, canTexture);
    texlightShader = loadShader("texlightFrag.glsl", "texlightVert.glsl");
}

void draw() {
    background(0);
    shader(texlightShader);
    pointLight(255, 255, 255, width/2, height, 200);
    
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