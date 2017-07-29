// SOME GAME MADE BY ME
//
// LOL

Player player;
Terrain t;

final int groundWidth = 3000;
final int groundDepth = 10000;

final int MAX_BLOCKS = 100;

Block[] blocks = new Block[MAX_BLOCKS];

float turnCameraOffset = 0;
float turnCameraOffset_tgt = 0;
float turnCameraAngle = 0;
float turnCameraAngle_tgt = 0;
float speedCameraOffset = 0;
float speedCameraOffset_tgt = 0;

void setup() {

    // initialize grpahics
    size(1280, 800, P3D);
    frameRate(60);
    
    // intialize game objects
    player = new Player();
    t = new Terrain();
    generateBlocks(blocks);

}

void draw() {
    background(#6589A7);
    drawLights();
    
    pushMatrix();
     //translate(width/2, height/2+100, -700);
     //rotateX(1.5 * PI - radians(map(mouseY, 0, height, 0, 90)));


    float mouseXNormalized = map(mouseX, 0, width, -1.0, 1.0);

    turnCameraOffset_tgt = mouseXNormalized * -100;
    turnCameraOffset = lerp(turnCameraOffset, turnCameraOffset_tgt, 0.1);
    turnCameraAngle_tgt = mouseXNormalized * PI / 12;
    turnCameraAngle = lerp(turnCameraAngle, turnCameraAngle_tgt, 0.1);
    speedCameraOffset_tgt = map(player.getSpeed(), 10, 100, -50, 150);
    speedCameraOffset = lerp(speedCameraOffset, speedCameraOffset_tgt, 0.1);

    translate(width/2 + turnCameraOffset, height/2+100, -150 - speedCameraOffset);
    rotateX(1.5 * PI - radians(5));
    rotateY(turnCameraAngle);
    
    // =====[ Draw objects in the 3D scene ]=====
    //drawGround();
    t.draw();
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
     //for (Block b : blocks) {
     //    b.draw();
     //}
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