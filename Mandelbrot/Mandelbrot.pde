void setup() {
  size(500, 500);
  pixelDensity(1);
}

void draw() {
  makeFractal();
}

void makeFractal() {
  loadPixels();
  for (int x = 0; x < width; x++) {
    for (int y = 0; y < height; y++) {

      // mouse map
      float mapFactor = map(mouseX, 0, width, 0.01, 2);

      // map for complex
      float a = map(x, 0, width, -2 * mapFactor, 2 * mapFactor);
      float b = map(y, 0, height, -2 * mapFactor, 2 * mapFactor);

      // initial values
      float a_0 = a;
      float b_0 = b;

      int n    = 0;
      float z = 0;

      while (n < 100) {
        // calculate a^2 - b^2
        float real    = a * a - b * b;
        float complex = 2 * a * b;

        // set real to a and b to complex
        a = real + a_0;
        b = complex + b_0;

        // break out
        if (abs(a + b) > 16) {
          break;
        }

        n++;
      }

      float brightness = map(n, 0, 100, 0, 255);

      pixels[y * width + x] = color(0, 100 - brightness, 0);
    }
  }
  updatePixels();
}
