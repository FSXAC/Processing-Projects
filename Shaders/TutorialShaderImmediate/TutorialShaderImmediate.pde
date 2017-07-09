PShape can;
float angle;

PShader pixlightShader;

boolean usePShape = false;
boolean optimStroke = true;

void setup() {
    size(640, 360, P3D);
    can = createCan(100, 200, 32);
    pixlightShader = loadShader("lightFrag.glsl", "lightVert.glsl");

    if (usePShape) println("using pshape");
    else println("using immediate mode");  
    if (optimStroke) println("enabled optimized stroke");
    else println("disabled optimized stroke");
}

void draw() {    
    background(0);

    shader(pixlightShader);

    pointLight(255, 255, 255, width/2, height, 200);

    translate(width/2, height/2);
    rotateY(angle);
    if (usePShape) shape(can);
    else drawCan(100, 200, 32);

    angle += 0.01;
}

PShape createCan(float r, float h, int detail) {
    textureMode(NORMAL);
    PShape sh = createShape();
    sh.beginShape(QUAD_STRIP);
    sh.noStroke();
    sh.fill(255);
    for (int i = 0; i <= detail; i++) {
        float angle = TWO_PI / detail;
        float x = sin(i * angle);
        float z = cos(i * angle);
        float u = float(i) / detail;
        sh.normal(x, 0, z);
        sh.vertex(x * r, -h/2, z * r, u, 0);
        sh.vertex(x * r, +h/2, z * r, u, 1);
    }
    sh.endShape(); 
    return sh;
}

void drawCan(float r, float h, int detail) { 
    beginShape(QUAD_STRIP);
    noStroke();
    for (int i = 0; i <= detail; i++) {
        float angle = TWO_PI / detail;
        float x = sin(i * angle);
        float z = cos(i * angle);
        float u = float(i) / detail;
        normal(x, 0, z);
        vertex(x * r, -h/2, z * r, u, 0);
        vertex(x * r, +h/2, z * r, u, 1);
    }
    endShape();
}

void keyPressed() {
    if (key == 'p') {
        usePShape = !usePShape;
        if (usePShape) println("using pshape");
        else println("using immediate mode");
    } else if (key == 'o') {
        optimStroke = !optimStroke;
        if (optimStroke) {
            hint(ENABLE_OPTIMIZED_STROKE);
            println("enabled optimized stroke");
        } else { 
            hint(DISABLE_OPTIMIZED_STROKE);
            println("disabled optimized stroke");
        }
    }
}