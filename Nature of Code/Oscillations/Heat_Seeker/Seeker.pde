class Seeker {
  PVector position, velocity;
  
  Seeker() {
    position = new PVector(random(0, width), random(0, height));
    velocity = new PVector(0, 0);
  }
  
  void chase() {
    // update physics
    velocity = PVector.sub(new PVector(mouseX, mouseY), position);
    position.add(velocity.normalize().mult(1));
    
    pushMatrix();
    // display
    fill(255, 170, 0);
    rect(position.x, position.y, 5, 10);
    
    // point in the right direction (acceleration rather than velocity)
    
    rotate(atan(velocity.y/velocity.x));
    popMatrix();
  }
}