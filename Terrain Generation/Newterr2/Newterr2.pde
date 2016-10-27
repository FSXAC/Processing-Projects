Terrain terrain;
float xmag, ymag = 0;
float newXmag, newYmag = 0;

void setup() {
  size(900, 500, P3D);
  terrain = new Terrain(20);

  // initialize
  terrain.generate(0.1);

  noStroke();
  smooth();
}

void mousePressed() {
  // regenerates
  terrain.generate(rough);
}

float rough = 0.5;
void keyPressed() {
  if (key=='w') {
    rough += 0.1;
  } else if (key == 's') {
    rough -= 0.1
  }
}


float moveX = 0;
float moveH = 0;

void draw()  {
  moveX += map(mouseX - width / 2, -(width/2), width/2, 8, -8);
  moveH += map(mouseY - height / 2, -(height/2), height/2, 8, -8);

  background(255);

  // light
  directionalLight(204, 204, 204, 0, 0, -1);

  // move camera
  pushMatrix();
  translate(width / 2 + moveX, height / 2, -30 + moveH);
  // translate(width / 2, height / 2, -30);

  rotateX(PI/3);

  scale(15);

  terrain.display();
  popMatrix();

  stroke(0);
  text(rough, 10, 10);
  noStroke(0);
}

class Terrain {
  private final int terrain_size;
  private final int max;
  private float[] map;
  private float roughness;

  // higher detain renders a larger terrain
  Terrain(int detail) {
    // size of the grid - squared for squared area, +1 for the center grid
    // more specifically side length of the grid
    terrain_size = int(pow(detail, 2) + 1);

    // maximum of each dimension
    max = terrain_size - 1;

    // use an array to store 2D height map
    map = new float[terrain_size * terrain_size];
  }

  // gets the value of a point on the map
  private float get(int x, int y) {
    // check that x and y are in bound
    if (x < 0 || x > max || y < 0 || y > max) {return -1;}
    else {return map[x + terrain_size * y];}
  }

  // sets the value of a point on the map
  private void set(int x, int y, float value) {
    if (!(x < 0 || x > max || y < 0 || y > max)) {
      map[x + terrain_size * y] = value;
    }
  }

  // function that generate map using MIDPOINT DISPLACEMENT METHOD
  public void generate(float r) {
    // set roughness
    roughness = r;

    // first set the 4 corners
    set(0, 0, terrain_size / 2);
    set(0, max, random(0, terrain_size / 8));
    set(max, 0, random(0, terrain_size));
    set(max, max, terrain_size / 4);

    divide(max);
  }

  // midpoint displacement algorithmn, divide
  // (based on github.com/hunterloftis/playfuljs-demos/blob/gh-pages/terrain)
  private void divide (int size) {
    int x, y;
    int half = size / 2;
    float scale = roughness * size;

    // stop
    if (half < 1) return;


    for (y = half; y < max; y += size) {
      for (x = half; x < max; x += size) {
        square(x, y, half, random(-scale, scale));
      }
    }

    for (y = 0; y <= max; y += half) {
      for (x = (y + half) % size; x <= max; x += size) {
        diamond(x, y, half, random(-scale, scale));
      }
    }

    // recursive
    divide(half);
  }

  // get the average of valid numbers in an array
  private float average(float[] values) {
    // keep track of sum and  how many are valid
    int valid = 0;
    float total = 0;

    // count them up
    for (int i = 0; i < values.length; i++) {
      if (values[i] != -1) {
        valid ++;
        total += values[i];
      }
    }

    // return 0 if nothing is valid
    return (valid == 0) ? 0 : total / valid;
  }

  private void square(int x, int y, int size, float offset) {
    // get average of surrounding
    float av = average(new float[] {
      get(x - size, y - size),    // upper left
      get(x + size, y - size),    // upper right
      get(x + size, y + size),    // lower right
      get(x - size, y + size)     // lower left
      });

    // set point as average plus random offset
    set(x, y, av + offset);
  }

  private void diamond(int x, int y, int size, float offset) {
    // get average of surrounding
    float av = average(new float[] {
      get(x, y - size),     // top
      get(x + size, y),     // right
      get(x, y + size),     // bottom
      get(x - size, y)      // left
      });

    // set point as average plus random offset
    set(x, y, av + offset);
  }

  public void display() {
    for (int y = 0; y < terrain_size - 1; y++) {
      for (int x = 0; x < terrain_size - 1; x++) {
        // draw triangle and verticies

        // first triangle fan
        beginShape(TRIANGLE_FAN);
        // fill(get(x, y));
        vertex(x, y, get(x, y));
        // fill(get(x + 1, y));
        vertex(x + 1, y, get(x + 1, y));
        // fill(get(x, y + 1));
        vertex(x, y + 1, get(x, y + 1));
        endShape(CLOSE);

        // second half
        beginShape(TRIANGLE_FAN);
        // fill(get(x + 1, y));
        vertex(x + 1, y, get(x + 1, y));
        // fill(get(x, y + 1));
        vertex(x, y + 1, get(x, y + 1));
        // fill(get(x + 1, y + 1));
        vertex(x + 1, y + 1, get(x + 1, y + 1));

        endShape(CLOSE);
      }
    }
  }
}
