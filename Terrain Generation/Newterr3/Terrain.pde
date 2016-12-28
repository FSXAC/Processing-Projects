class Terrain {
  private int terrain_width;
  private float[] map;
  
  // constructor
  Terrain(int size) {
    this.terrain_width = size;
    this.map = new float[size * size];
    
    // generate random terrain
    this.generate();
  }
  
  // Generates random terrain and saves to a map array
  public void generate() {
    for (int y = 0; y < this.terrain_width; y++) {
      for (int x = 0; x < this.terrain_width; x++) {
        this.map[y * this.terrain_width + x] = 10 * noise(x, y);
      }
    }
  }
 
  // *** GETTERS and SETTERS
  private float get(int x, int y) {
    if (x < 0 || y < 0 || x > this.terrain_width || y > this.terrain_width) return -1;
    else return map[y * terrain_width + x];
  }
   
  public void display() {
    for (int y = 0; y < this.terrain_width; y++) {
      for (int x = 0; x < this.terrain_width; x++) {
        // draw triangle and verticies
        beginShape(TRIANGLE_FAN);
        vertex(x, y, this.get(x, y));
        vertex(x + 1, y, this.get(x + 1, y));
        vertex(x, y + 1, this.get(x, y + 1));
        endShape(CLOSE);
        
        // second half of the triangle
        beginShape(TRIANGLE_FAN);
        vertex(x + 1, y, get(x + 1, y));
        vertex(x, y + 1, get(x, y + 1));
        vertex(x + 1, y + 1, get(x + 1, y + 1));
        endShape(CLOSE);
      }
    }
  }
}