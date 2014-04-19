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

public class robotTest extends PApplet {

Robot r;
public void setup() {
  size(800, 600, P3D);
  colorMode(HSB);
  background(255);
  
  r = new Robot(width/2, height/2);
  
  println("Press space to assign new destination");
}
public void draw() {
  background(255);
  camera(width/2.0f, height * 2, (height/4.0f) / tan(PI*30.0f / 180.0f), width/2.0f, height/2.0f, 0, 0, 1, 0); 
  
  r.update();
  r.draw();
}
public void keyPressed() {
  if(key == ' ') {
    r.setRandomTarget();
  }
}
class Robot {
  PVector pos, tpos;
  float sz, dir, speed;
  int c;

  Robot(float x, float y) {
    pos = new PVector(x, y);
    tpos = new PVector(x, y); 
    this.dir = 0;
    this.sz = 40;
    this.speed = 5;
    c = color(random(255), 200, 100);
  }

  public void draw() {
    rectMode(CENTER);
    noStroke();
    
    pushMatrix();
    translate(pos.x, pos.y);
    scale(sz);
    rotate(dir);

    fill(c);

    box(1.0f, 0.8f, 0.1f);

    pushMatrix();
    translate(0, 0.5f);
    box(1.0f, 0.1f, 0.3f);
    popMatrix();
    
    pushMatrix();
    translate(0, -0.5f);
    box(1.0f, 0.1f, 0.3f);
    popMatrix();

    fill(255);

    pushMatrix();
    translate(0.4f, 0.2f, 0.2f);
    box(0.1f);
    popMatrix();
    
    pushMatrix();
    translate(0.4f, -0.2f, 0.2f);
    box(0.1f);
    popMatrix();

    popMatrix();
  }
  public void update() {
    if (pos.dist(tpos) < 1) {
      return;
    }

    float tdir = atan2(tpos.y - pos.y, tpos.x - pos.x);
    float dirDiff = tdir - dir;
    PVector pDiff = PVector.sub(tpos, pos);

    if (abs(dirDiff) < 0.05f) {
      dir = tdir;
      if (pDiff.mag() > 5) {
        // move
        pDiff.normalize();
        pDiff.mult(5);
        pos.add(pDiff);
      }
    } else {
      // rotate
      dir += dirDiff > 0 ? 0.05f : -0.05f;
    }
  }

  public void setRandomTarget() {
    tpos.x = random(width);
    tpos.y = random(height);
  }
}

  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "robotTest" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
