class Terrain {
  private int size;
  private float[] map;
  private float[] offset_terrain = {0, 0};

  // constructor
  Terrain(int size) {
    this.size = size;
    this.map  = new float[size * size + 1];

    // generate random terrain
    this.generate();
  }

  // Generates random terrain and saves to a map array
  public void generate() {
    for (int z = 0; z < this.size; z++) {
      for (int x = 0; x < this.size; x++) {
        this.map[z * this.size + x] = T_AMP * noise(
          (x + offset_terrain[0]) * T_RES, (z + offset_terrain[1]) * T_RES
        );
      }
    }
  }

  // returns the height at specific x and z
  private float get(int x, int z) {
    if (x < 0 && z >= 0 && z < this.size)               return get(x + 1, z);
    else if (x >= 0 && z < 0 && z < this.size)          return get(x, z + 1);
    else if (z >= 0 && x >= this.size && z < this.size) return get(x - 1, z);
    else if (x >= 0 && x < this.size && z >= this.size) return get(x, z - 1);
    else if (x < 0 && z < 0)                            return get(0, 0);
    else if (x >= this.size && z >= this.size)          return get(x - 1, z - 1);
    else                                                return map[z * size + x];
  }

  private void fillColour(float level) {
    if (level < T_THRES)
      // set water depth color
      fill(lerpColor(
        color(58, 42, 14),
        color(224, 219, 197),
        map(level, T_THRES / 2, T_THRES, 0, 1)
      ));
    else fill(lerpColor(
        color(11, 56, 8),
        color(255, 255, 255),
        map(level, T_THRES, T_AMP, 0, 1)
      ));
  }

  public void display() {
    for (int z = 0; z < this.size; z++) {
      for (int x = 0; x < this.size; x++) {
        // draw triangle and verticies
        // beginShape(TRIANGLE_FAN);
        // fillColour(this.get(x, z));
        // vertex(x * T_SIZE,       this.get(x, z),     z * T_SIZE);
        // fillColour(this.get(x+1, z));
        // vertex((x + 1) * T_SIZE, this.get(x + 1, z), z * T_SIZE);
        // fillColour(this.get(x, z+1));
        // vertex(x * T_SIZE,       this.get(x, z + 1), (z + 1) * T_SIZE);
        // endShape(CLOSE);
        //
        // // second half of the triangle
        // beginShape(TRIANGLE_FAN);
        // fillColour(this.get(x+1, z));
        // vertex((x + 1) * T_SIZE, get(x + 1, z),     z * T_SIZE);
        // fillColour(this.get(x, z+1));
        // vertex(x * T_SIZE,       get(x, z + 1),     (z + 1) * T_SIZE);
        // fillColour(this.get(x+1, z+1));
        // vertex((x + 1) * T_SIZE, get(x + 1, z + 1), (z + 1) * T_SIZE);
        // endShape(CLOSE);

        beginShape(QUADS);
        fillColour(this.get(x, z));
        vertex(x * T_SIZE, this.get(x, z), z * T_SIZE);
        fillColour(this.get(x + 1, z));
        vertex((x + 1) * T_SIZE, this.get(x + 1, z), z * T_SIZE);
        fillColour(this.get(x + 1, z + 1));
        vertex((x + 1) * T_SIZE, get(x + 1, z + 1), (z + 1) * T_SIZE);
        fillColour(this.get(x, z + 1));
        vertex(x * T_SIZE, this.get(x, z + 1), (z + 1) * T_SIZE);
        endShape(CLOSE);
      }
    }
  }

  // moves the terrain by offsetting perlin noise
  public void moveTerrain(float dx, float dz) {
    offset_terrain[0] += dx;
    offset_terrain[1] += dz;
  }
}
