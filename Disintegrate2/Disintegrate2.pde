import peasy.*;

PeasyCam cam;

final String IMG_PATH = "bug.png";
final float PIXEL_SIZE = 1;
final int IMG_WIDTH = 600;

final boolean USE_3D = true;

class Particle {
	private float x;
	private float y;
	private color c;

	Particle(float x, float y, color c) {
		this.x = x;
		this.y = y;
		this.c = c;
	}

	public draw() {
		pushMatrix();
		translate(this.x, this.y, this.z);

		// Draws the particle
		fill(this.c);
		if (USE_3D) {
			box(PIXEL_SIZE);
		} else {
			rect(0, 0, PIXEL_SIZE, PIXEL_SIZE);
		}

		popMatrix();

		// Update
		this.update();
	}

	private update() {
		noise(x, y, z);
	}
}