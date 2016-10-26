class Terrain {
  private final int size;
  private final int max;
  private float[] map;
  private float roughness;

  // higher detain renders a larger terrain
  Terrain(int detail) {
    // size of the grid - squared for squared area, +1 for the center grid
    // more specifically side length of the grid
    size = pow(detail, 2) + 1;

    // maximum of each dimension
    max = size - 1;

    // use an array to store 2D height map
    map = new float[size * size];

    // generate map using MIDPOINT DISPLACEMENT METHOD
    // set the 4 corners
    map[0, 0]
  }

  // gets the value of a point on the map
  private float get(int x, int y) {
    // check that x and y are in bound
    if (x < 0 || x > max || y < 0 || y > max) {return -1;}
    else {return map[x + size * y];}
  }

  // sets the value of a point on the map
  private void set(int x, int y, float value) {
    if (!(x < 0 || x > max || y < 0 || y > max)) {
      map[x + size * y] = value;
    }
  }

  // function that generates the terrain
  public void generate() {
    // first set the 4 corners
    set(0, 0, max);
    set(0, max, max / 2);
    set(max, 0, max / 2);
    set(max, max, max);

    divide(max);
  }

  // midpoint displacement algorithmn, divide
  // (based on github.com/hunterloftis/playfuljs-demos/blob/gh-pages/terrain)
  private int divide (int size) {
    int x, y;
    int half = size / 2;
    float scale = roughness * size;

    // stop
    if (half < 1) return 0;


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
}

void setup() {
  size(1280, 720, P3D);
}

void draw() {

}
