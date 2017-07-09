//int maxR = 0;
int r = 0;
int k = 20;


void setup() {
    size(1280, 800, P3D);
}

void draw() {
    background(255);
    strokeWeight(5);
    stroke(0);
    translate(width / 2, height / 2);
    int dots = 0;
    //for (int r = 0; r < maxR; r++) {
        for (int x = -r; x <= r; x++) {
            point(k * x, k * r);
            dots++;
            
            if (r == 0) continue;
            
            point(k * x, k * -r);
            dots++;
        }
        
        for (int y = -r + 1; y < r; y++) {
            point(k * r, k * y);
            point(k * -r, k * y);
            dots += 2;
        }
    //}
    r = r > 15 ? 0 : r + 1;
    println(dots);
}

void mousePressed() {
    //maxR++;
    r++;
}