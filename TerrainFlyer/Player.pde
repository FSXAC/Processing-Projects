class Player {
    // constants
    public final float TURN_ROLL_ANGLE = 0;
    // public final float TURN_ROLL_ANGLE = PI/3;
    public final float TURN_YAW_ANGLE = 0;
    public final float TURN_SENSITIVITY = 15;
    
    private float speed;
    private float speed_tgt;
    private float acceleration;
    private float turnValue;
    
    private PShape playerModel;
    private PShape exhaustModel;
    private boolean usingExternShape = true;
    
    private PlayerTrail playerTrail;
    
    PShader playerShader;
    
    Player() {
        speed_tgt = 30;
        acceleration = 1;
        
        // create geometry of the ship
        if (usingExternShape) {
            playerModel = loadShape("rocket.obj");
            playerModel.scale(0.5);
            playerModel.rotateY(-PI / 2);
            this.createExhaustGeometry();
        } else {
            playerModel = createShape(GROUP);
            this.createGeometry();
        }
        
        // player trail
        playerTrail = new PlayerTrail();
        
        // load shaders
        playerShader = loadShader("playerFrag.glsl", "playerVert.glsl");
    }
    
    public void draw() {
        pushMatrix();
        stroke(0);
        noFill();
        
        // transform the camera
        translate(0, -height / 2, -50);
        rotateY(map(turnValue, 0, width, TURN_ROLL_ANGLE, -TURN_ROLL_ANGLE));
        rotateZ(map(turnValue, 0, width, TURN_YAW_ANGLE, -TURN_YAW_ANGLE));
        this.renderGeometry();
        
        popMatrix();
        
        // call the update function to update stats
        this.update();
    }
    
    public float getSpeed() {
        return this.speed;
    }
    
    public float getHorizonalSpeed() {
        return this.turnValueToHorizontalSpeed(this.turnValue);
    }
    
    private void update() {
        // update any private members here
        turnValue = lerp(turnValue, mouseX, 0.3);
        // speed = lerp(speed, map(mouseY, 0, height, 100, 10), 0.1);
        acceleration = map(mouseY, 0, height, 1.0, -1.0);
        speed_tgt = constrain(speed_tgt + acceleration, 10, 100);
        speed = lerp(speed, speed_tgt, 0.1);
    }
    
    private void renderGeometry() {
        shader(playerShader);
        shape(playerModel);
        resetShader();
        
        if (usingExternShape) {
            shape(exhaustModel);
            pointLight(255, 255, 255, 0, 0, 0);
        }
        
        // this.playerTrail.draw();
    }
    
    private void createGeometry() {
        // render the ship
        PShape playerQuad = createShape();
        playerQuad.beginShape(QUADS);
        playerQuad.fill(0, 0, 0);
        playerQuad.vertex(-15, 50, -30);    // front
        playerQuad.fill(0, 0, 255);
        playerQuad.vertex(15, 50, -30);
        playerQuad.fill(0, 255, 0);
        playerQuad.vertex(25, 40, 0);
        playerQuad.fill(0, 255, 255);
        playerQuad.vertex(-25, 40, 0);
        playerQuad.fill(255, 0, 0);
        playerQuad.vertex(-25, 40, 0);      // bottom
        playerQuad.fill(255, 0, 255);
        playerQuad.vertex(25, 40, 0);
        playerQuad.fill(255, 255, 0);
        playerQuad.vertex(50, -50, 0);
        playerQuad.fill(255, 255, 255);
        playerQuad.vertex(-50, -50, 0);
        playerQuad.endShape();
        
        fill(33, 99, 255);
        PShape playerTri = createShape();
        playerTri.beginShape(TRIANGLES);
        playerTri.vertex(-15, 50, -30);    // top
        playerTri.vertex(15, 50, -30);
        playerTri.vertex(0, -50, -40);
        playerTri.vertex(0, -50, -40);    // left
        playerTri.vertex(-50, -50, 0);
        playerTri.vertex(-15, 50, -30);
        playerTri.vertex(0, -50, -40);    // right
        playerTri.vertex(50, -50, 0);
        playerTri.vertex(15, 50, -30);
        playerTri.vertex(0, -50, -40);    // back
        playerTri.vertex(-50, -50, 0);
        playerTri.vertex(50, -50, 0);
        playerTri.endShape();
        
        playerModel.addChild(playerQuad);
        playerModel.addChild(playerTri);
    }
    
    private void createExhaustGeometry() {
        exhaustModel = createShape();
        exhaustModel.beginShape(TRIANGLE);
        exhaustModel.fill(255, 255, 255);
        exhaustModel.noStroke();
        exhaustModel.specular(255);
        exhaustModel.vertex(-10, 0, 0);
        exhaustModel.vertex(10, 0, 0);
        exhaustModel.fill(0, 255, 255);
        exhaustModel.vertex(0, -random(80, 130) * map(speed, 10, 100, 0.5, 3), 0);
        exhaustModel.endShape();
    }
    
    private float turnValueToHorizontalSpeed(float turnValue) {
        return map(turnValue, 0, width, -TURN_SENSITIVITY, TURN_SENSITIVITY);
    }
}

class PlayerTrail {
    
    private int numSegments;
    private float segmentLength;
    
    private PVector[] segmentPosBuffer;
    
    PlayerTrail() {
        numSegments = 20;
        segmentLength = 10;
        
        segmentPosBuffer = new PVector[numSegments];
        for (int i = 0; i < numSegments; i++) {
            segmentPosBuffer[i] = new PVector(0, 0, 0);
        }
    }
    
    public void draw() {
        stroke(0);
        strokeWeight(5);
        pushMatrix();
        rotateZ(-PI / 2);
        translate(0, 0, -30);
        
        for (int i = 0; i < numSegments; i++) {
            PVector vec = segmentPosBuffer[i];
            if (i == 0) {
                line(0, 0, 0, vec.x, vec.y, vec.z);
            } else {
                PVector prevVec = segmentPosBuffer[i - 1];
                line(prevVec.x, prevVec.y, prevVec.z, vec.x, vec.y, vec.z);
            }
        }
        
        pushMatrix();
        PVector endPos = segmentPosBuffer[numSegments - 1];
        translate(endPos.x, endPos.y, endPos.z);
        noStroke();
        fill(100);
        sphere(10);
        popMatrix();
        
        popMatrix();
        this.update();
    }
    
    private void update() {
        float playerSpeed = player.getSpeed();
        PVector playerVec = new PVector(playerSpeed + random(-1, 1), -player.getHorizonalSpeed() + random(-1, 1), 0);
        playerVec.normalize();
        playerVec.mult(segmentLength);
        
        for (int i = numSegments - 1; i > 0;  i--) {
            PVector vec = segmentPosBuffer[i-1].copy();
            vec.add(playerVec);
            segmentPosBuffer[i] = vec;
        }
        
        segmentPosBuffer[0] = playerVec.copy();
    }
}