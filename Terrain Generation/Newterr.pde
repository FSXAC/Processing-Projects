class Terrain {
  int size;
  int max;
  float[] map;

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
  float get(int x, int y) {
    // check that x and y are in bound
    if (x < 0 || x > max || y < 0 || y > max) {return -1;}
    else {return map[x + size * y];}
  }

  // sets the value of a point on the map
  void set(int x, int y, float value) {
    if (!(x < 0 || x > max || y < 0 || y > max)) {
      map[x + size * y] = value;
    }
  }

  // function that generates the terrain
  void generate() {
    // first set the 4 corners
    set(0, 0, max);
    set(0, max, max / 2);
    set(max, 0, max / 2);
    set(max, max, max);
  }
}


void setup() {


}

void draw() {

}
