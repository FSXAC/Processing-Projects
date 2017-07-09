class Block {
    private PVector position;
    
    PShape blockModel;
    private PVector corner1;
    private PVector corner2;
    private PVector corner3;
    private PVector corner4;
    
    Block() {
        this.resetPosition();
        blockModel = createShape();
        this.generateShape();
    }
    
    Block(PVector initialPosition) {
        this.position = initialPosition;
        blockModel = createShape();
        this.generateShape();
    }
    
    public void resetPosition() {
        this.position = new PVector(random(-groundWidth, groundWidth), random(groundDepth-1000, groundDepth), 0);
    }
    
    public void draw() {
        pushMatrix();
        translate(position.x, position.y, position.z);
        shape(blockModel);
        popMatrix();
        
        this.update();
    }
    
    private void generateShape() {       
        corner1 = new PVector(random(25, 50), random(-50, -25), random(-200, -50));
        corner2 = new PVector(random(25, 50), random(25, 50), random(-200, -50));
        corner3 = new PVector(random(-50, -25), random(25, 50), random(-200, -50));
        corner4 = new PVector(random(-50, -25), random(-50, -25), random(-200, -50));
        
        blockModel.beginShape(QUADS);
        blockModel.fill(150, 120, 130);
        blockModel.noStroke();
        
        // front
        blockModel.vertex(50, -50, 0);
        blockModel.vertex(corner1.x, corner1.y, corner1.z);
        blockModel.vertex(corner4.x, corner4.y, corner4.z);
        blockModel.vertex(-50, -50, 0);
        // left
        blockModel.vertex(-50, -50, 0);
        blockModel.vertex(corner4.x, corner4.y, corner4.z);
        blockModel.vertex(corner3.x, corner3.y, corner3.z);
        blockModel.vertex(-50, 50, 0);
        // right
        blockModel.vertex(50, -50, 0);
        blockModel.vertex(corner1.x, corner1.y, corner1.z);
        blockModel.vertex(corner2.x, corner2.y, corner2.z);
        blockModel.vertex(50, 50, 0);
        // top
        blockModel.vertex(corner1.x, corner1.y, corner1.z);
        blockModel.vertex(corner2.x, corner2.y, corner2.z);
        blockModel.vertex(corner3.x, corner3.y, corner3.z);
        blockModel.vertex(corner4.x, corner4.y, corner4.z);
        blockModel.endShape(CLOSE);
    }
    
    private void update() {        
        position.y -= player.getSpeed();
        position.x -= player.getHorizonalSpeed();
        
        // check if out of bound, if so reset
        if (position.y < -1000 || position.x > groundWidth || position.x < -groundWidth) {
            this.resetPosition();
        }
    }
}