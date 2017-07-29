int[] terrainChunkOffset = { 3000, 3000 };

class Terrain {
    static final int chunkWidth = 12;
    static final int chunkDepth = 9;
    
    ArrayList<TerrainChunk> tChunks = new ArrayList<TerrainChunk>();

    int[] terrainOffset = { 0, 0 };
    int[] terrainMoveOffset = { 0, 0 };

    Terrain() {
        this.generateChunks(0, 0, chunkWidth, chunkDepth);
    }

    void generateChunks(int startx, int starty, int w, int h) {
        tChunks.clear();
        for (int x = 0; x < w; x++) {
            for (int y = 0; y < h; y++) {
                tChunks.add(new TerrainChunk(startx + x, starty + y));
            }
        }
    }

    void draw() {
        pushMatrix();
        rotateX(PI / 2);
        translate(-0.5 * chunkWidth * TerrainChunk.CHUNK_SIZE * TerrainChunk.TILE_SIZE, -TerrainChunk.AMPLITUDE*0.0, -1.0 * chunkDepth * TerrainChunk.CHUNK_SIZE * TerrainChunk.TILE_SIZE);
        translate(terrainMoveOffset[0], 0, terrainMoveOffset[1]);
        translate(-terrainOffset[0] * TerrainChunk.CHUNK_SIZE * TerrainChunk.TILE_SIZE, 0, -1.0 * (terrainOffset[1] - 1) * TerrainChunk.CHUNK_SIZE * TerrainChunk.TILE_SIZE);
        for (int i = 0; i < tChunks.size(); i++) {
            tChunks.get(i).draw();
        }
        /*if (keyPressed) {
            if (key == CODED) {
                if (keyCode == UP) {
                    terrainMoveOffset[1] += 30;
                    checkChunkCoords();
                } else if (keyCode == DOWN) {
                    terrainMoveOffset[1] -= 30;
                    checkChunkCoords();
                } else if (keyCode == LEFT) {
                    terrainMoveOffset[0] += 30;
                    checkChunkCoords();
                } else if (keyCode == RIGHT) {
                    terrainMoveOffset[0] -= 30;
                    checkChunkCoords();
                }
            }
        }*/
        terrainMoveOffset[1] += player.getSpeed();
        println(player.getSpeed());
        terrainMoveOffset[0] += -player.getHorizonalSpeed();
        checkChunkCoords();
        popMatrix();
    }

    void checkChunkCoords() {
        int step = int(TerrainChunk.CHUNK_SIZE * TerrainChunk.TILE_SIZE);
        if (terrainMoveOffset[1] > step) {
            terrainMoveOffset[1] = terrainMoveOffset[1] % step;
            terrainOffset[1]--;
            generateChunks(terrainOffset[0], terrainOffset[1], chunkWidth, chunkDepth);
        } else if (terrainMoveOffset[1] < -step) {
            terrainMoveOffset[1] = terrainMoveOffset[1] % step;
            terrainOffset[1]++;
            generateChunks(terrainOffset[0], terrainOffset[1], chunkWidth, chunkDepth);
        }
        
        if (terrainMoveOffset[0] >step) {
            terrainMoveOffset[0] = terrainMoveOffset[0] % step;
            terrainOffset[0]--;
            generateChunks(terrainOffset[0], terrainOffset[1], chunkWidth, chunkDepth);
        } else if (terrainMoveOffset[0] < -step) {
            terrainMoveOffset[0] = terrainMoveOffset[0] % step;
            terrainOffset[0]++;
            generateChunks(terrainOffset[0], terrainOffset[1], chunkWidth, chunkDepth);
        }
    }
}

class TerrainChunk {
    static final float AMPLITUDE = 1000;
    static final float SCALE = 10;
    static final float TILE_SIZE = 100;
    static final int CHUNK_SIZE = 8;

    private float[] heightMap;
    private float[] chunkCoord = {0, 0};

    PShape chunk;

    TerrainChunk(int chunkX, int chunkY) {
        this.heightMap = new float[CHUNK_SIZE * CHUNK_SIZE + 1];
        this.generateHeightMap();
        
        this.chunkCoord[0] = chunkX;
        this.chunkCoord[1] = chunkY;
    }
    
    public void draw() {
        this.generateHeightMap();
        this.renderTerrainImm();
    }

    public void renderTerrainImm() {
        pushMatrix();
        noStroke();
        //translate(
        //    (chunkCoord[0] - terrainOffset[0]) * CHUNK_SIZE * TILE_SIZE, 
        //    0, 
        //    (chunkCoord[1] - terrainOffset[1]) * CHUNK_SIZE * TILE_SIZE
        //    );
                //translate(
        translate(chunkCoord[0] * CHUNK_SIZE * TILE_SIZE, 0, chunkCoord[1] * CHUNK_SIZE * TILE_SIZE);
        // textSize(50);
        // text("(" + str(chunkCoord[0]) + ", " + str(chunkCoord[1]) + ")", 0, 0);
        beginShape(QUADS);
        float o, a1, a2, d;
        for (int y = 0; y < CHUNK_SIZE; y++) {
            for (int x = 0; x < CHUNK_SIZE; x++) {
                o  = getHeightAt(x, y);
                a1 = getHeightAt(x + 1, y);
                a2 = getHeightAt(x, y + 1);
                d  = getHeightAt(x + 1, y + 1);

                fillColor(o);
                vertex(x * TILE_SIZE, o, y * TILE_SIZE);
                fillColor(a1);
                vertex((x + 1) * TILE_SIZE, a1, y * TILE_SIZE);
                fillColor(d);
                vertex((x + 1) * TILE_SIZE, d, (y + 1) * TILE_SIZE);
                fillColor(a2);
                vertex(x * TILE_SIZE, a2, (y + 1) * TILE_SIZE);
            }
        }
        endShape();
        popMatrix();
    }

    public void generateShape() {
        chunk.beginShape(QUADS);
        chunk.noStroke();
        float o, a1, a2, d;
        for (int y = 0; y < CHUNK_SIZE; y++) {
            for (int x = 0; x < CHUNK_SIZE; x++) {
                o  = getHeightAt(x, y);
                a1 = getHeightAt(x + 1, y);
                a2 = getHeightAt(x, y + 1);
                d  = getHeightAt(x + 1, y + 1);

                fillColor(o);
                chunk.vertex(x * TILE_SIZE, o, y * TILE_SIZE);
                fillColor(a1);
                chunk.vertex((x + 1) * TILE_SIZE, a1, y * TILE_SIZE);
                fillColor(d);
                chunk.vertex((x + 1) * TILE_SIZE, d, (y + 1) * TILE_SIZE);
                fillColor(a2);
                chunk.vertex(x * TILE_SIZE, a2, (y + 1) * TILE_SIZE);
            }
        }
        chunk.endShape();
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
                    ((terrainChunkOffset[0] + chunkCoord[0]) * (CHUNK_SIZE - 1) + i) / SCALE,
                    ((terrainChunkOffset[1] + chunkCoord[1]) * (CHUNK_SIZE - 1) + j) / SCALE
                );
                // noiseHeight = -AMPLITUDE * (noiseHeight - 0.5);
                noiseHeight = AMPLITUDE * noiseHeight;
                this.heightMap[j * CHUNK_SIZE + i] = noiseHeight;
            }
        }
    }

    private void fillColor(float level) {
        if (level < (AMPLITUDE * 0.4)) {
            fill(lerpColor(
                color(58, 42, 41),
                color(224, 219, 197),
                map(level, (AMPLITUDE * 0.4) / 2, (AMPLITUDE * 0.4), 0, 1)
            ));
        } else if (level < AMPLITUDE * 0.7) {
            // land
            fill(lerpColor(
                color(54, 84, 31),
                color(198, 204, 142),
                map(level, (AMPLITUDE * 0.4), AMPLITUDE, 0, 1)
            ));
        } else {
            fill(255, 255, 255);
        }
    }
}