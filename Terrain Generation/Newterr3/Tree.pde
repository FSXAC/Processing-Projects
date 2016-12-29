// basic spherical tree
class Tree {
  private float height;
  private float radius;
  private boolean enabled;

  // constructor
  Tree() {
    height = random(8) + 5;
    radius = random(height / 2) + height / 4;
  }

  // draw the tree
  public void drawTree(float x, float y, float z) {
    pushMatrix();
    translate(x, y, z);
    fill(45, 34, 15);
    drawCylinder(1, height, 3);
    translate(0, radius, 0);
    fill(69, 158, 18);
    sphere(radius);
    popMatrix();
  }
}

// family of trees
class Forest {
  // generate forest on a separate perlin noise
  private Tree[] trees = new Tree[T_DIM * T_DIM];
  private float[] tree_map = new float[T_DIM * T_DIM];

  Forest() {
    for (int i = 0; i < T_DIM * T_DIM; i++) {
      this.trees[i] = new Tree();
    }

    // initial generation
    this.generate();
  }

  // generate perlin noise for the trees
  public void generate() {
    for (int z = 0; z < T_DIM; z++) {
      for (int x = 0; x < T_DIM; x++) {
        this.tree_map[z * T_DIM + x] = noise((x + offset_terrain[0]) * TREE_RES, (z + offset_terrain[1]) * TREE_RES);
      }
    }
  }

  // draw the trees naturally onto the terrain
  public void drawForest(float[] terrain_map) {
    float index, level;
    for (int z = 0; z < T_DIM; z++) {
      for (int x = 0; x < T_DIM; x++) {
        index = z * T_DIM;
        level = terrain_map[index];
        if (level > T_THRES && level < T_AMP * 0.7 && this.tree_map[index] > 0.5) {
          trees[index].drawTree(x, level, z);
        }
      }
    }
  }
}
