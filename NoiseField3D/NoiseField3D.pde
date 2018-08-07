import peasy.*;

PeasyCam cam;

final int SIZE_X = 10;
final int SIZE_Y = 10;
final int SIZE_Z = 10;
final float STEP = 10;

long seedX = 0;
long seedY = 0;
long seedZ = 0;
long seedMag = 0;
float maxAmplitude = 10;

float scaleX = 0.001;
float scaleY = 0.001;
float scaleZ = 0.001;

// Global array
PVector[][][] field;

void createField() {
	field = null;
	field = new PVector[SIZE_X][SIZE_Y][SIZE_Z];

	for (int i = 0; i < SIZE_X; i++) {
		for (int j = 0; j < SIZE_Y; j++) {
			for (int k = 0; k < SIZE_Z; k++) {
				noiseSeed(seedX);
				float dx = noise(i, j, k) - 0.5;

				noiseSeed(seedY);
				float dy = noise(i, j, k) - 0.5;

				noiseSeed(seedZ);
				float dz = noise(i, j, k) - 0.5;

				noiseSeed(seedMag);
				// TODO: option to visualize color and draw unit vectors
				float mag = (noise(i, j, k) - 0.5) * 2 * maxAmplitude;

				PVector dv = new PVector(dx, dy, dz);
				dv.mult(mag);

				// add to array
				field[i][j][k] = dv;
			}
		}
	}
}

void drawArrow(PVector point, PVector v) {
	// TODO: a line for now
	pushMatrix();
	translate(point.x, point.y, point.z);


	// TODO: colored strokes
	stroke(255);
	line(0, 0, 0, v.x, v.y, v.z);

	popMatrix();
}

void setup() {
  size(1280, 900, P3D);

  cam = new PeasyCam(this, 800);
  createField();

  background(0);
}

void draw() {
  if (field == null) {
    return;
  }
  
  background(0);
  
	pushMatrix();

	for (int i = 0; i < SIZE_X; i++) {
		for (int j = 0; j < SIZE_Y; j++) {
			for (int k = 0; k < SIZE_Z; k++) {
				drawArrow(
					new PVector(i * STEP, j * STEP, k * STEP),
					field[i][j][k]
				);
			}
		}
	}

	popMatrix();
}
