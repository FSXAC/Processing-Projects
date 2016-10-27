import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class Newterr2 extends PApplet {

Terrain terrain;
float xmag, ymag = 0;
float newXmag, newYmag = 0;

public void setup() {
  
  terrain = new Terrain(10);

  // initialize
  terrain.generate(0.5f);

  noStroke();
}

public void mousePressed() {
  // regenerates
  terrain.generate(0.5f);
}

public void draw()  {
  background(255);

  // light
  directionalLight(204, 204, 204, 0, 0, -1);

  // move camera
  pushMatrix();
  translate(width / 2 + map(mouseX, 0, width, 0, -200),
  height / 2, -30 + map(mouseY, 0, height, 0, 200));
  // translate(width / 2, height / 2, -30);

  rotateX(PI/3);

  scale(15);

  terrain.display();
  popMatrix();
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
    terrain_size = PApplet.parseInt(pow(detail, 2) + 1);

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
    set(0, 0, random(0, 10));
    set(0, max, random(0, 10));
    set(max, 0, random(0, 10));
    set(max, max, random(0, 10));

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
        vertex(x, y, get(x, y));
        vertex(x + 1, y, get(x + 1, y));
        vertex(x, y + 1, get(x, y + 1));
        endShape(CLOSE);

        // second half
        beginShape(TRIANGLE_FAN);
        vertex(x + 1, y, get(x + 1, y));
        vertex(x, y + 1, get(x, y + 1));
        vertex(x + 1, y + 1, get(x + 1, y + 1));

        endShape(CLOSE);
      }
    }
  }
}
  public void settings() {  size(900, 500, P3D); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "--present", "--window-color=#272727", "--stop-color=#cccccc", "Newterr2" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
