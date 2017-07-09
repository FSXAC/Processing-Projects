// SOME GAME MADE BY ME
//
// LOL

Player player;
Terrain terrain;



final int groundWidth = 3000;
final int groundDepth = 10000;

final int MAX_BLOCKS = 100;

Block[] blocks = new Block[MAX_BLOCKS];

void setup() {

    // initialize grpahics
    size(1280, 800, P3D);
    frameRate(60);
    
    // intialize game objects
    player = new Player();
    generateBlocks(blocks);
    
    terrain = new Terrain(100);
    terrain.generateHeightMap();
}

void draw() {
    background(#6589A7);
    drawLights();
    
    pushMatrix();
    // translate(width/2, height/2+100, -700);
    // rotateX(1.5 * PI - radians(map(mouseY, 0, height, 0, 90)));
    translate(width/2, height/2+100, -150);
    rotateX(1.5 * PI - radians(5));
    
    // =====[ Draw objects in the 3D scene ]=====
    //drawGround();
    
    terrain.draw();
    player.draw();
    drawBlocks(blocks);
    // =====[ End of objects in the 3D scene ]=====
    
    popMatrix();
}

// generate a bunch of blocks
void generateBlocks(Block[] blocks) {
    for (int i = 0; i < blocks.length; i++) {
        blocks[i] = new Block(new PVector(random(-groundWidth, groundWidth), random(500, groundDepth)));
    }
}

void drawBlocks(Block[] blocks) {
    for (Block b : blocks) {
        b.draw();
    }
}

void drawLights() {
    ambientLight(50, 50, 50);
    directionalLight(255, 255, 255, 0, 1, 0);
    directionalLight(255, 255, 255, 0, 0, -1);
}

void drawGround() {
    pushMatrix();   
    beginShape(QUAD_STRIP);
    noStroke();
    //noLights();
    
    fill(100);
    vertex(-2 * groundWidth, -0.1 * groundDepth, 0);
    vertex(2 * groundWidth, -0.1 * groundDepth, 0);
    
    fill(#6589A7);
    vertex(-2 * groundWidth, 0.4 * groundDepth, 0);
    vertex(2 * groundWidth, 0.4 * groundDepth, 0);
    vertex(-2 * groundWidth, 2 * groundDepth, 0);
    vertex(2 * groundWidth, 2 * groundDepth, 0);
    
    endShape();
    popMatrix();
}