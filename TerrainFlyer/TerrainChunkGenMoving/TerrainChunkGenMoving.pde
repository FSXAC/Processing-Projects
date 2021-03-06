import queasycam.*;

//import peasy.*;
//PeasyCam cam;

QueasyCam cam;

ArrayList<TerrainChunk> tChunks = new ArrayList<TerrainChunk>();
int r = 0;
float[] GLOBAL_TERRAIN_OFFSET = { 0, 0 };

int moveX = 0;
int moveY = 0;
int moveXPos = 0;
int moveYPos = 0;

void setup() {
    size(1280, 800, P3D);
    //fullScreen(P3D);

    //cam = new PeasyCam(this, 100);
    //cam.setMinimumDistance(50);
    //cam.setMaximumDistance(500);
    //cam.setSuppressRollRotationMode();
    cam = new QueasyCam(this);
    cam.speed = 5;
    cam.sensitivity = 0.5;
    noCursor();
    
    generateChunks(0, 0, 10, 10);
}

int fov = 60;
void mouseWheel(MouseEvent event) {
    float e = event.getCount();
    if (e > 0) {
        if (fov < 120) fov += 5;
    } else {
        if (fov > 30) fov -= 5;
    }
    perspective(radians(fov), width / height, 0.1, 10000);
    println(fov);
}


void draw() {
    background(#6589A7);
    
    for (int i = 0; i < tChunks.size(); i++) {
        tChunks.get(i).draw();
    }
    if (keyPressed) {
        if (key == CODED) {
             if (keyCode == UP) {
                 moveYPos += 3;
                 checkChunkCoords();
             } else if (keyCode == DOWN) {
                 moveYPos -= 3;
                 checkChunkCoords();
             } else if (keyCode == LEFT) {
                 moveXPos += 3;
                 checkChunkCoords();
             } else if (keyCode == RIGHT) {
                 moveXPos -= 3;
                 checkChunkCoords();
             }
         }
    }
}

void checkChunkCoords() {
    if (moveYPos > 80) {
        moveYPos = moveYPos % 80;
        moveY--;
        generateChunks(moveX, moveY, 10, 10);
    } else if (moveYPos < -80) {
        moveYPos = moveYPos % 80;
        moveY++;
        generateChunks(moveX, moveY, 10, 10);
    }
    
    if (moveXPos > 80) {
        moveXPos = moveXPos % 80;
        moveX--;
        generateChunks(moveX, moveY, 10, 10);
    } else if (moveXPos < -80) {
        moveXPos = moveXPos % 80;
        moveX++;
        generateChunks(moveX, moveY, 10, 10);
    }
}

void generateChunks(int startx, int starty, int w, int h) {
    tChunks.clear();
    for (int x = 0; x < w; x++) {
        for (int y = 0; y < h; y++) {
            tChunks.add(new TerrainChunk(startx + x, starty + y));
        }
    }
}

class TerrainChunk {
    private float AMPLITUDE = 200;
    private float SCALE = 10;
    private float TILE_SIZE = 10;
    private int CHUNK_SIZE = 8;

    private float[] heightMap;
    private float[] translation = {0, 0};

    PShape chunk;

    TerrainChunk(int chunkX, int chunkY) {
        this.heightMap = new float[CHUNK_SIZE * CHUNK_SIZE + 1];
        this.generateHeightMap();
        
        this.translation[0] = chunkX;
        this.translation[1] = chunkY;
    }
    
    public void draw() {
        this.generateHeightMap();
        this.renderTerrainImm();
    }

    public void renderTerrainImm() {
        pushMatrix();
        noStroke();
        translate(
            (translation[0] - moveX) * CHUNK_SIZE * TILE_SIZE + moveXPos, 
            0, 
            (translation[1] - moveY) * CHUNK_SIZE * TILE_SIZE + moveYPos
            );
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
                    ((GLOBAL_TERRAIN_OFFSET[0] + translation[0]) * (CHUNK_SIZE - 1) + i) / SCALE,
                    ((GLOBAL_TERRAIN_OFFSET[1] + translation[1]) * (CHUNK_SIZE - 1) + j) / SCALE
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