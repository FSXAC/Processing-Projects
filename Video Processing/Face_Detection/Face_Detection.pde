import gab.opencv.*;

import processing.video.*;

import java.awt.*;



Capture video;

OpenCV opencv;



void setup() {

  size(640, 480);

  video = new Capture(this, 640/2, 480/2);

  opencv = new OpenCV(this, 640/2, 480/2);

  opencv.loadCascade(OpenCV.CASCADE_FRONTALFACE);  



  video.start();

}



void draw() {

  scale(2);

  opencv.loadImage(video);



  image(video, 0, 0 );



  noFill();

  stroke(0, 255, 0);

  strokeWeight(3);

  Rectangle[] faces = opencv.detect();

  println(faces.length);



  for (int i = 0; i < faces.length; i++) {

    println(faces[i].x + "," + faces[i].y);

    strokeWeight(1);
    //rect(faces[i].x, faces[i].y, faces[i].width, faces[i].height);
    ellipse(faces[i].x + faces[i].width / 4, 
    faces[i].y + 2* faces[i].height / 5, faces[i].width/5, faces[i].width/5);
    ellipse(faces[i].x + 3 *faces[i].width / 4, 
    faces[i].y + 2 * faces[i].height / 5, faces[i].width/5, faces[i].width/5);
    line(faces[i].x+faces[i].width/3, faces[i].y+faces[i].height*0.8, 
    faces[i].x+2*faces[i].width/3, faces[i].y+faces[i].height*0.8);
    
  }

}



void captureEvent(Capture c) {

  c.read();

}