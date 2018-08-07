
import peasy.*;

PeasyCam cam;

// Constants
final String IMG_PATH = "bug.png";
final boolean FILL_IMG = false;
final float PIXEL_SIZE = 1;

final float MAX_AMPLITUDE = -500;

final boolean AUTO_PLAY = false;

float g_autoplay_x = 0;
boolean g_recording = false;

PImage sampleImage;

void setup() {
	size(1280, 900, P3D);
	noStroke();

	// 3D camera
	cam = new PeasyCam(this, 800);
	cam.setMinimumDistance(40);
	cam.setMaximumDistance(500);

	if (cam == null) {
		noLoop();
	}
	
	// Set up image
	sampleImage = loadImage(IMG_PATH);
	float scaleFactor = getImageConstrainFitFactor(sampleImage.width, sampleImage.height, width, height);
	sampleImage.resize(int(sampleImage.width * scaleFactor), int(sampleImage.height * scaleFactor));
}

void draw() {
	background(255);

	if (cam != null) {
		translate(-width/2, -height/2, 0);
	}

	drawImage();

	if (AUTO_PLAY) {
		if (g_autoplay_x < 0.00000001) {
			g_autoplay_x = 1;
		} else {
			g_autoplay_x *= 0.95;
		}
	}

	if (g_recording) {
		saveFrame("frames/" + str(frameCount) + ".tif");
		if (cam != null) {
			cam.beginHUD();
			fill(255, 0, 0);
			ellipse(50, 50, 30, 30);
			cam.endHUD();
		} else {
			fill(255, 0, 0);
			ellipse(50, 50, 30, 30);
		}
	}

}

void drawImage() {
	// Draw image at the center of the screen
	float cornerX = width / 2 - sampleImage.width / 2;
	float cornerY = height / 2 - sampleImage.height / 2;
	// image(sampleImage, cornerX, cornerY);

	// Plot each pixel
	for (int i = 0; i < sampleImage.width; i += PIXEL_SIZE) {
		for (int j = 0; j < sampleImage.height; j += PIXEL_SIZE) {
			fill(sampleImage.get(i, j));

			pushMatrix();
			float transZ = disintegrateAmplitude(i, j, sampleImage.width, sampleImage.height);
			float pixelScale = map(abs(transZ), 0, abs(MAX_AMPLITUDE), 1, 0.3);
			translate(0, 0, transZ);
			rect(cornerX + i, cornerY + j, PIXEL_SIZE * pixelScale, PIXEL_SIZE * pixelScale);
			popMatrix();
		}
	}
}

float noiseCentered(float x, float y, float amp) {
	return amp * noise(x, y) - (amp / 2);
}

float getImageConstrainFitFactor(float imgWidth, float imgHeight, float screenWidth, float screenHeight) {
	final float screenRatio = screenWidth / screenHeight;
	final float imgRatio = imgWidth / imgHeight;
	
	if (imgRatio > screenRatio) {
		// Image is wider than the screen; constrain by width
		if (imgWidth > screenWidth || FILL_IMG) {
			return screenWidth / imgWidth;
		}
	} else {
		// Constrain by height
		if (imgHeight > screenHeight || FILL_IMG) {
			return screenHeight / imgHeight;
		}
	}
	return 1;
}

float disintegrateAmplitude(float x, float y, float maxX, float maxY) {
	if (AUTO_PLAY) {
		float amp = MAX_AMPLITUDE * exp(-x * x * g_autoplay_x);
		return noiseCentered(
			0.03 * x, 0.03 * y, amp * constrain(
				map(g_autoplay_x, 0.0005, 0.000001, 1.0, 3.0), 1.0, 3.0));
	} else {
		float amp = MAX_AMPLITUDE * exp(-x * x * map(mouseX, 0, width, 0.0005, 0.000001));
		return noiseCentered(0.03 * x, 0.03 * y, amp * map(mouseX, 0, width, 1.0, 3.0));
	}
}


void keyPressed() {
	if (keyCode == 82) {	// [r]
		if (g_recording) {
			g_recording = false;
		} else {
			g_recording = true;
		}
	}
}
