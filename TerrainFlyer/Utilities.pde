void drawAxis() {
    stroke(255, 0, 0);            // x
    line(0, 0, 0, 100, 0, 0);   
    stroke(0, 255, 0);            // y
    line(0, 0, 0, 0, 100, 0);
    stroke(0, 0, 255);            // z
    line(0, 0, 0, 0, 0, -100);
}