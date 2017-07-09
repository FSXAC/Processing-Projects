class Player {
    // constants
    public final float TURN_ROLL_ANGLE = PI/3;
    public final float TURN_YAW_ANGLE = PI/12;
    public final float TURN_SENSITIVITY = 15;
    
    private float speed;
    private float turnValue;
    
    private PShape playerModel;
    private PShape exhaustModel;
    private boolean usingExternShape = true;
    
    private PlayerTrail playerTrail;
    
    Player() {
        speed = 30;
        
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
    }
    
    private void renderGeometry() {
        shape(playerModel);
        
        if (usingExternShape) {
            shape(exhaustModel);
        }
        
        this.playerTrail.draw();
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
        numSegments = 5;
        segmentLength = 10;
        
        segmentPosBuffer = new PVector[numSegments];
        for (int i = 0; i < numSegments; i++) {
            segmentPosBuffer[i] = new PVector(0, 0, 0);
        }
    }
    
    public void draw() {
        PVector vec;
        stroke(0);
        strokeWeight(10);
        for (int i = 0; i < numSegments; i++) {
            vec = segmentPosBuffer[i];
            if (i == 0) {
                line(0, 0, 0, vec.x, vec.y, vec.z);
            } else {
                line(0, 0, 0, vec.x, vec.y, vec.z);/////// n n
            }
        }
        
        this.update();
    }
    
    private void update() {
        PVector playerVec = new PVector(player.getSpeed(), player.getHorizonalSpeed(), 0);
        playerVec.normalize();
        playerVec.mult(segmentLength);
        
        segmentPosBuffer[0] = new PVector(0, 0, 0);//////////////
        for (int i = numSegments - 1; i > 0;  i--) {
            PVector vec = segmentPosBuffer[i-1].copy();
            vec.add(playerVec);
            segmentPosBuffer[i] = vec;
        }
        
        segmentPosBuffer[0] = playerVec.copy();
        
        println(segmentPosBuffer);
    }
}