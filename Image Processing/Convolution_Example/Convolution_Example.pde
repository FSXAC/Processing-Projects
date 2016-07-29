PImage img;
// The convolution matrix for a "sharpen" effect stored as a 3 x 3 two-dimensional array.
float[][] matrix1 = {{1, 1, 1}, {1, -9, 1}, {1, 1, 1}};
float[][] matrix2 = {{-1, -1, -1}, {-1, 9, -1}, {-1, -1, -1}};
float[][] matrix3 = {{0.1, 0.1, 0.1}, {0.1, 0.1, 0.1}, {0.1, 0.1, 0.1}};
float[][] matrix4 = {{1, -1, 1}, {-1, 1, -1}, {1, -1, 1}};

int mode = 0;

void setup() {
  size(1000,750);
  img = loadImage( "/../boat_resized.jpg" );
}

void draw() {
  
  // We're only going to process a portion of the image
  // so let's set the whole image as the background first
  image(img,0,0);
  
  int matrixsize = 3;
  
  loadPixels();
  // Begin our loop for every pixel
  for (int x = 0; x < width; x++ ) {
    for (int y = 0; y < height; y++ ) {
      // Each pixel location (x,y) gets passed into a function called convolution()
      // The convolution() function returns a new color to be displayed.
      int index = x + y*img.width;
      color c;
      
      if (mode == 1) {
        c = convolution(x,y,matrix1,matrixsize,img); 
      } else if (mode == 2) {
        c = convolution(x,y,matrix2,matrixsize,img); 
      } else if (mode == 3) {
        c = convolution(x,y,matrix3,matrixsize,img);         
      } else if (mode == 4) {
        c = convolution(x,y,matrix4,matrixsize,img);         
      } else {
        c = img.pixels[index];
      }
      
      pixels[index] = c;
    }
  }
  updatePixels();
}

void mousePressed() {
  if (mode != 4) {
    mode++;
  } else {
    mode = 0;
  }
}

color convolution(int x, int y, float[][] matrix, int matrixsize, PImage img) {
  float rtotal = 0.0;
  float gtotal = 0.0;
  float btotal = 0.0;
  int offset = matrixsize / 2;
  
  // Loop through convolution matrix
  for (int i = 0; i < matrixsize; i++ ) {
    for (int j = 0; j < matrixsize; j++ ) {
      
      // What pixel are we testing
      int xloc = x + i-offset;
      int yloc = y + j-offset;
      int loc = xloc + img.width*yloc;
      
      // Make sure we haven't walked off the edge of the pixel array
      // It is often good when looking at neighboring pixels to make sure we have not gone off the edge of the pixel array by accident.
      loc = constrain(loc,0,img.pixels.length-1);
      
      // Calculate the convolution
      // We sum all the neighboring pixels multiplied by the values in the convolution matrix.
      rtotal += (red(img.pixels[loc]) * matrix[i][j]);
      gtotal += (green(img.pixels[loc]) * matrix[i][j]);
      btotal += (blue(img.pixels[loc]) * matrix[i][j]);
    }
  }
  
  // Make sure RGB is within range
  rtotal = constrain(rtotal,0,255);
  gtotal = constrain(gtotal,0,255);
  btotal = constrain(btotal,0,255);
  
  // Return the resulting color
  return color(rtotal,gtotal,btotal); 
}