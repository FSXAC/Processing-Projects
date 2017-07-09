import peasy.*;

PeasyCam cam;
TerrainChunk[] tChunks = new TerrainChunk[16];

void setup() {
    size(1280, 800, P3D);

    cam = new PeasyCam(this, 100);
    cam.setMinimumDistance(50);
    cam.setMaximumDistance(500);
    cam.setSuppressRollRotationMode();
    
    for (int i = 0; i < 16; i++) {
        tChunks[i] = new TerrainChunk(i % 4, i / 4);
    }
}

int test = 0;
void draw() {
    background(#6589A7);
    
    for (int i = 0; i < 16; i++) {
        tChunks[i].draw(i == test);
    }
    
    box(10);
    pushMatrix();
    translate(0, -5, 0);
   
    box(5);
    popMatrix();
}

void keyPressed() {
    test = test == 15 ? 0 : test + 1;
}

class TerrainChunk {
    private float AMPLITUDE = 100;
    private float SCALE = 1;
    private float TILE_SIZE = 10;
    private int CHUNK_SIZE = 8;

    private float[] heightMap;
    private float[] translation = {0, 0};

    TerrainChunk(int chunkX, int chunkY) {
        this.heightMap = new float[CHUNK_SIZE * CHUNK_SIZE + 1];
        this.generateHeightMap();
        
        this.translation[0] = chunkX;
        this.translation[1] = chunkY;
    }

    public void draw(boolean selected) {
        if (selected) fill(#88FF88);
        else fill(255);
        this.generateHeightMap();
        this.renderTerrain();
    }

    public void renderTerrain() {
        pushMatrix();
        translate(translation[0] * CHUNK_SIZE * TILE_SIZE, 0, translation[1] * CHUNK_SIZE * TILE_SIZE);
        beginShape(QUADS);
        float o, a1, a2, d;
        for (int y = 0; y < CHUNK_SIZE; y++) {
            for (int x = 0; x < CHUNK_SIZE; x++) {
                o  = getHeightAt(x, y);
                a1 = getHeightAt(x + 1, y);
                a2 = getHeightAt(x, y + 1);
                d  = getHeightAt(x + 1, y + 1);

                vertex(x * TILE_SIZE, o, y * TILE_SIZE);
                vertex((x + 1) * TILE_SIZE, a1, y * TILE_SIZE);
                vertex((x + 1) * TILE_SIZE, d, (y + 1) * TILE_SIZE);
                vertex(x * TILE_SIZE, a2, (y + 1) * TILE_SIZE);
            }
        }
        endShape();
        popMatrix();
    }

    public float getHeightAt(int x, int y) {
        // Corner cases
        if      (inside(y) && x < 0)
            return getHeightAt(0, y);                           // x too small
        else if (inside(x) && y < 0)
            return getHeightAt(x, 0);                           // y too small
        else if (inside(y) && x >= CHUNK_SIZE)
            return getHeightAt(CHUNK_SIZE - 1, y);              // x too big
        else if (inside(x) && y >= CHUNK_SIZE)
            return getHeightAt(x, CHUNK_SIZE - 1);              // y too big
        else if (x < 0 && y < 0)
            return getHeightAt(0, 0);                           // x and y too small
        else if (x >= CHUNK_SIZE && y >= CHUNK_SIZE)
            return getHeightAt(CHUNK_SIZE - 1, CHUNK_SIZE - 1); // x and y too big
        else
            return heightMap[y * CHUNK_SIZE + x];
    }

    private boolean inside(int n) {
        return (n >= 0 && n < CHUNK_SIZE);
    }

    private void generateHeightMap() {
        for (int i = 0; i < CHUNK_SIZE; i++) {
            for (int j = 0; j < CHUNK_SIZE; j++) {
                float noiseHeight = noise(
                    (translation[0] * (CHUNK_SIZE - 1) + i) / SCALE,
                    (translation[1] * (CHUNK_SIZE - 1) + j) / SCALE
                );
                noiseHeight = -AMPLITUDE * (noiseHeight - 0.5);
                this.heightMap[j * CHUNK_SIZE + i] = noiseHeight;
            }
        }
    }
}