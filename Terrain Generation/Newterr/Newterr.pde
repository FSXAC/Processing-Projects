Terrain terrain;

void initialize() {
  background(255);
  terrain.generate(0.5);
  terrain.display();
}

void setup() {
  size(900, 500, P3D);
  terrain = new Terrain(20);

  // initialize terrain
  initialize();
}

void draw() {

}

void mousePressed() {
  // regenerates
  initialize();
}

void keyPressed() {
  // capture screen
  if (key == 's') {
    saveFrame("####.jpg");
  }
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
    set(0, 0, max);
    set(0, max, max / 2);
    set(max, 0, max / 2);
    set(max, max, max);

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

  // display map
  private void display() {
    float water_z = terrain_size * 0.3;

    // height
    float z;

    for (int y = 0; y < terrain_size; y++) {
      for (int x = 0; x < terrain_size; x++) {
        // get the height of each spot
        z = get(x, y);

        // create vectors to draw
        PVector top    = project(x, y, z);
        PVector bottom = project(x + 1, y, 0);
        PVector water  = project(x, y, water_z);

        // color and brightness based on height
        // land
        color land_color = getBrightness(x, y, get(x + 1, y) - z);
        drawVector(top, bottom, land_color);

        // water
        color water_color = color(50, 150, 200, 255 * 0.15);
        drawVector(water, bottom, water_color);
      }
    }
  }

  // isometric transformation
  private PVector iso(float x, float y) {
    return new PVector(0.5 * (terrain_size + x - y), 0.5 * (x + y));
  }

  // project given x and y into a vector
  private PVector project(float fx, float fy, float fz) {
    // point at (x, y) and level z
    PVector point = iso(fx, fy);

    float x0 = width  * 0.5;
    float y0 = height * 0.5;
    float x = (point.x - terrain_size * 0.5) * 6;
    float y = (terrain_size - point.y) * 0.005 + 1;
    float z = terrain_size * 0.5 - fz + point.y * 0.75;

    // return the modified point
    return new PVector(x0 + x / y, y0 + z / y);
  }

  // color the land based on position and slope
  private color getBrightness(float x, float y, float slope) {
    // ignore the side for slopes
    if (y == max || x == max) return (0);
    else return color(slope * 50 + 128);
  }

  // draw the vectors
  private void drawVector(PVector top, PVector bottom, color c) {
    // don't draw anything if the top is below bottom (bigger z = lower)
    if (bottom.y < top.y) return;
    else {
      noStroke();
      fill(c);
      rect(top.x, top.y, bottom.x - top.x, bottom.y - top.y);
    }
  }
}
