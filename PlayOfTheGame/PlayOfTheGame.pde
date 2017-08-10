import processing.sound.*;

Title victoryTitle;
PFont g_titleFont;
SoundFile g_victorySound;

void setup() {
	size(1280, 800);

	g_titleFont = createFont("data/big_noodle_titling_oblique.ttf", 100, true);
	g_victorySound = new SoundFile(this, "victory.mp3");
	
	victoryTitle = new Title("Testing");
}

void draw() {
	background(255);
	if (victoryTitle.playing()) victoryTitle.draw();
}

void mousePressed() {
	victoryTitle.play();
}

class Title {
	private String message;
	private color textColor;

	private int lastFrame = 260;
	private int frame = 0;
	private boolean isEnabled = false;

	private float xOffset;
	private float yOffset;

	private boolean flash;
	private boolean flashC;
	private boolean flashI;

	Title (String message) {
		this.message = message;
	}

	// draw the title
	public void draw() {
		if (this.isEnabled) {
			noStroke();

			float bgOpacity = constrain(map(this.frame, 0, 20, 0, 200), 0, 200);
			bgOpacity -= constrain(map(this.frame, 178, this.lastFrame, 0, 200), 0, 200);
			fill(0, bgOpacity);
			rect(0, 0, width, height);

			// change fill for text color
			this.textColor = color(
				//rgb
				255,
				constrain(map(this.frame, 40, 120, 255, 213),0, 255),
				constrain(map(this.frame, 30, 40, 255, 0), 0, 255) + constrain(map(this.frame, 40, 120, 0, 74), 0, 255),

				// alpha
				constrain(map(this.frame, 10, 20, 0, 255), 0, 255) - constrain(map(this.frame, 178, 230, 0, 255), 0, 255)
			);

			// format text
			textAlign(CENTER, CENTER);
			textFont(g_titleFont);
			textSize(int(map(this.frame, 10, 230, 250, 100)));

			// flashes
			this.flashCircle();
			this.flashText();

			fill(this.textColor);
			text(this.message, width / 2, height / 2 - 50);

			// flash initials
			flashInitial();

			// update text
			update();
		}
	}

	public boolean playing() {
		return this.isEnabled;
	}

	private void flashCircle() {
		if (this.flashC) {
			noFill();
			stroke(255);
			strokeWeight(constrain(map(this.frame, 10, 40, 30, 0), 0, 30));
			float diameter = map(this.frame, 10, 60, 50, 500);
			ellipse(width / 2 - 20 * this.message.length(), height / 2 - 60, diameter, diameter);
		}
	}

	private void flashText() {
		if (this.flash) {
			this.xOffset = random(-10, 10);
			this.yOffset = random(-10, 10);
			fill(this.textColor);
			pushMatrix();
			translate(width / 2 + this.xOffset, height / 2 - 50 + this.yOffset);
			for (int v = -1; v < 2; v++) {
				text(this.message, 3 * v, 0);
				text(this.message, 0, 3 * v);
			}
			fill(0);
			text(this.message, 0, 0);
			popMatrix();
		}
	}

	private void flashInitial() {
		if (this.flashI) {
			fill(255);
			textSize(int(map(this.frame, 0, 15, 800, 150)));
			text(this.message.charAt(0), width / 2 - 35 * this.message.length(), height / 2 - 50);
		}
	}

	private void update() {
		flash = (this.frame > 20 && this.frame < 70) && !flash;
		flashC = (this.frame > 10 && this.frame < 40);
		flashI = (this.frame < 15);
		if (this.frame < this.lastFrame) {
			this.frame++;
		} else {
			this.isEnabled = false;
		}
	}

	private void play() {
		this.frame = 0;
		this.isEnabled = true;
		g_victorySound.play();
	}
}