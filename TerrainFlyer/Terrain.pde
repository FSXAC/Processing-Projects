class Terrain {
    private final float AMPLITUDE = 400;
    private final float RES = 0.1;
    private final float TILE_SIZE = 100;

    private int size;
    private float[] heightMap;
    private float[] translation = {0, 0};

    Terrain(int size) {
        this.size = size;
        this.heightMap = new float [size * size + 1];
        this.generateHeightMap();
    }

    public void draw() {
        pushMatrix();
        translate(-(this.size * TILE_SIZE)/2, -height / 2, AMPLITUDE);
        rotateX(-PI / 2);
        this.renderTerrain();
        popMatrix();

        this.update();
    }

    public void update() {
        this.translation[0] += RES * 0.2 * player.getHorizonalSpeed();
        this.translation[1] += RES * 0.2 * player.getSpeed();
        this.generateHeightMap();
    }

    public void renderTerrain() {
        beginShape(QUADS);
        noStroke();

        float o, a1, a2, d;

        for (int y = 0; y < this.size; y++) {
            for (int x = 0; x < this.size; x++) {
                o  = this.get(x, y);
                a1 = this.get(x + 1, y);
                a2 = this.get(x, y + 1);
                d  = this.get(x + 1, y + 1);

                vertex(x * TILE_SIZE, o, y * TILE_SIZE);
                vertex((x + 1) * TILE_SIZE, a1, y * TILE_SIZE);
                vertex((x + 1) * TILE_SIZE, d, (y + 1) * TILE_SIZE);
                vertex(x * TILE_SIZE, a2, (y + 1) * TILE_SIZE);
            }
        }
        endShape();
    }
    
    private void generateHeightMap() {
        for (int y = 0; y < this.size; y++) {
            for (int x = 0; x < this.size; x++) {
                float noiseHeight = noise(RES * (x + translation[0]), RES * (y + translation[1]));
                this.heightMap[y * this.size + x] = AMPLITUDE * noiseHeight;
            }
        }
    }

    // return the height at specified x and z
    private float get(int x, int z) {
        if (x < 0 && z >= 0 && z < this.size)               return get(x + 1, z);
        else if (x >= 0 && z < 0 && z < this.size)          return get(x, z + 1);
        else if (z >= 0 && x >= this.size && z < this.size) return get(x - 1, z);
        else if (x >= 0 && x < this.size && z >= this.size) return get(x, z - 1);
        else if (x < 0 && z < 0)                            return get(0, 0);
        else if (x >= this.size && z >= this.size)          return get(x - 1, z - 1);
        else                                                return heightMap[z * this.size + x];
    }

    
}