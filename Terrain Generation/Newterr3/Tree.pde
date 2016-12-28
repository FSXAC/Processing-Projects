// basic spherical tree
class Tree {
  private float height;
  private float radius;

  // constructor
  Tree() {
    height = random(20) + 5;
    radius = random(height / 2) + height / 4;
  }

  // draw the tree
  public void drawTree(float x, float y, float z) {
    pushMatrix();
    translate(x, y, z);
    fill(45, 34, 15);
    drawCylinder(1, 6, 3);
    translate(0, 6, 0);
    fill(69, 158, 18);
    sphere(3);
    popMatrix();
  }
}
