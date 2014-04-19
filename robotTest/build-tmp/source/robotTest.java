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
//Plant3D p;
PlantGroup plants;

PImage tracks;

public void setup() {
  size(800, 600, P3D);
  colorMode(HSB);
  background(255);
  rectMode(CENTER);

  r = new Robot(width/2, height/2);
  //p = new Plant3D(width/2, height/2);

  plants = new PlantGroup();

  tracks = createImage(1600, 1200, RGB);
  tracks.loadPixels();
  for (int i = 0; i < tracks.pixels.length; i++) {
    tracks.pixels[i] = color(32, 50, random(210, 230));
  }
  tracks.updatePixels();

  println("Press space to assign new destination");
}
public void draw() {
  background(0xffE2F0C4);

  float camx = 200 * sin(frameCount * 0.001f);
  float camy = 200 * cos(frameCount * 0.001f);

  camera(
  r.pos.x, r.pos.y + height*0.5f, height * 0.5f, 
  r.pos.x + camx, r.pos.y + camy, r.pos.z, 
  0, 1, 0);
  hint(ENABLE_DEPTH_TEST);
  drawGround();
  r.update();
  r.draw();

  plants.update();
  plants.draw();

  //p.draw();  

  camera();
  hint(DISABLE_DEPTH_TEST);
  r.emo.draw();
}
public void drawGround() {
  beginShape();
  textureMode(NORMAL);
  texture(tracks);
  vertex(0, 0, 0, 0);
  vertex(width, 0, 1, 0);
  vertex(width, height, 1, 1);
  vertex(0, height, 0, 1);
  endShape();
}
public void keyPressed() {
  if (key == ' ') {
    r.setRandomTarget();
  }
  if (key == 'p') {
    plants.seed_plant(r.pos.x, r.pos.y);
  }
}

class Emo {
  PImage img;
  PVector pos;

  Emo() {
    load();
    pos = new PVector();
  }  
  public void load() {
    img = loadImage("icon" + nf(1 + PApplet.parseInt(random(21)), 3) + ".png");
  }
  public void setPos(float x, float y) {
    pos.x = x;
    pos.y = y;
  }
  public void draw() {
    image(img, pos.x + 20, pos.y - 50);
  }
}
class Plant 
{ 

  float x, y; // positions
  float age; // in seconds
  float size, size_min, size_max;
  float growth_rate;
  float time_born;
  boolean fully_grown, can_spawn;
  int generation;
  int hue, saturation, value;

  public Plant(float x, float y, int hue, int generation)
  {
    this.x = x;
    this.y = y;
    this.time_born = millis()/1000.0f;
    this.age = 0.0f;
    this.size_min = 1;
    this.size_max = 30;
    this.growth_rate = 20.0f;
    this.size = size_min;
    this.fully_grown = false;
    this.can_spawn = true;
    this.generation = generation;
    this.saturation = 200;
    this.hue = hue;
    this.value = 255;
  }

  public void draw()
  {
    lights();
    pushMatrix();
    noStroke();
    fill(this.hue, this.value, this.saturation);
    translate(this.x, this.y, 0);
    sphereDetail(5);
    sphere( this.size/2.0f );
    popMatrix();
    noLights();
  }

  public void update(float dt)
  {
    this.age = millis()/1000.0f - this.time_born; 

    update_growth();
  }

  public void update_growth() {
    this.size =  this.size_min + this.growth_rate * this.age;
    this.value = PApplet.parseInt( 255.0f - 55.0f*this.size_max/this.size );
    if (this.size > this.size_max) 
    {
      this.size = this.size_max;
      this.fully_grown = true;
    }
    if (this.size < this.size_min)
    {
      this.size = this.size_min;
    }
  }


  public void randomize_growth() {
    float exponential_factor = exp( - this.generation * 0.1f );
    this.size_max = (5.0f + randomGaussian())/6.0f * 30.0f * exponential_factor;
    this.growth_rate = (5.0f + randomGaussian())/(5.0f + 1.0f) * 10 * exponential_factor;
    this.saturation = PApplet.parseInt( exponential_factor * this.saturation );

    if (random(1.0f) > exponential_factor) 
    {
      this.can_spawn = false;
    }
  }
}

class Plant3D {
  private final int LEVELS = 50;
  PVector pos;
  int age;
  PShape[] plant;
  
  Plant3D(float x, float y) {
    pos = new PVector(x, y);
    age = 0;
    plant = new PShape[LEVELS];

    PVector posa = pos.get();
    PVector posb = pos.get();
    for(int i=0; i<LEVELS; i++) {
      posb = posa.get();
      posb.z += 10;
      plant[i] = createPrism(posa, posb);
      posa = posb.get();
    }
  }
  
  public void draw() {
    for(int i=0; i<age; i++) {
      shape(plant[i]);
    }
    age = min(LEVELS, age + 1);
  }
  public PShape createPrism(PVector a, PVector b) {
    float d = PVector.dist(a, b) * 0.5f;
    float T3 = TAU / 3;
    PVector p1 = new PVector(b.x + d * cos(T3*1), b.y + d * sin(T3*1), b.z);
    PVector p2 = new PVector(b.x + d * cos(T3*2), b.y + d * sin(T3*2), b.z);
    PVector p3 = new PVector(b.x + d * cos(T3*3), b.y + d * sin(T3*3), b.z);
    PShape sh = createShape();
    sh.beginShape(TRIANGLES);
    sh.noStroke();
    sh.fill(random(100, 200));
    
    sh.vertex(p1.x, p1.y, p1.z);
    sh.vertex(p2.x, p2.y, p2.z);
    sh.vertex(p3.x, p3.y, p3.z);

    sh.vertex(p1.x, p1.y, p1.z);
    sh.vertex(p2.x, p2.y, p2.z);
    sh.vertex(a.x, a.y, a.z);

    sh.vertex(p2.x, p2.y, p2.z);
    sh.vertex(p3.x, p3.y, p3.z);
    sh.vertex(a.x, a.y, a.z);

    sh.vertex(p3.x, p3.y, p3.z);
    sh.vertex(p1.x, p1.y, p1.z);
    sh.vertex(a.x, a.y, a.z);
    
    sh.endShape();
    return sh;
  }
}
class PlantGroup {

  ArrayList<Plant> vegetation;

  PlantGroup() 
  {
    vegetation = new ArrayList<Plant>();
  }

  public void seed_plant(float x, float y)
  {
    Plant root = new Plant(x, y, PApplet.parseInt(random(80, 130)), 0);
    root.randomize_growth();
    vegetation.add(root);
  }

  public void draw()
  {
    for (int p=0; p<vegetation.size(); p++)
    {
      Plant plant = vegetation.get(p);
      plant.draw();
    }
  }

  public void update()
  {

    for (int p=0; p<vegetation.size(); p++)
    {
      Plant plant = vegetation.get(p);
      plant.update(0);
    }
    for (int p=0; p<vegetation.size(); p++)
    {
      Plant plant = vegetation.get(p);
      if (plant.fully_grown == true && plant.can_spawn) 
      {
        for (int s=0; s<random(3,6); s++) {
          float radius = plant.size_max + 4.0f;
          float angle = random(0.0f, TAU);

          float sx, sy;
          sx = radius * cos(angle) + plant.x;
          sy = radius * sin(angle) + plant.y;

          boolean does_not_overlap = true;

          for (int p2=0; p2<vegetation.size(); p2++) 
          {
            Plant plant2=vegetation.get(p2);
            if (dist(sx, sy, plant2.x, plant2.y) < plant2.size_max || outside_screen(sx, sy))
            {
              does_not_overlap = false;
              break;
            }
          }

          if ( does_not_overlap) 
          {
            Plant sapling = new Plant(sx, sy, plant.hue, plant.generation+1);
            sapling.randomize_growth();
            vegetation.add(sapling);
          }
        }
        plant.can_spawn = false;
      }
    }
  }

  public boolean outside_screen(float x, float y) 
  {
    if (x<0 || x>width || y<0 || y>height)
    {
      return true;
    }
    return false;
  }
}

class Robot {
  public static final int STILL = 0;
  public static final int MOVING = 1;
  public static final int ROTATING = 2;
  PVector pos, tpos;
  float sz, dir, speed;
  int c;
  int mode;
  Emo emo;

  Robot(float x, float y) {
    pos = new PVector(x, y);
    tpos = new PVector(x, y); 
    this.dir = 0;
    this.sz = 40;
    this.speed = 5;
    c = color(random(255), 200, 100);
    
    emo = new Emo();
    mode = STILL;
  }

  public void draw() {
    noStroke();
    
    pushMatrix();
    translate(pos.x, pos.y);
    scale(sz);
    rotate(dir);

    fill(c);

    box(1.0f, 0.8f, 0.1f);
    
    emo.setPos(screenX(0, 0, 0), screenY(0, 0, 0));

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
        mode = MOVING;
      } else {
        mode = STILL;
      }
    } else {
      // rotate
      dir += dirDiff > 0 ? 0.05f : -0.05f;
      mode = ROTATING;
    }
  }

  public void setRandomTarget() {
    tpos.x = random(width);
    tpos.y = random(height);
    emo.load();
    mode = STILL;
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
