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

public class botsBehaviour extends PApplet {

Robots robots;
PlantGroup plants;

PImage tracks;

public void setup() {
  size(1344, 768, P3D);
  colorMode(HSB);
  background(255);
  noFill();
  rectMode(CENTER);

  robots = new Robots(1, 3);
  plants = new PlantGroup();

  tracks = createImage(1600, 1200, RGB);
  tracks.loadPixels();
  for (int i = 0; i < tracks.pixels.length; i++) {
    tracks.pixels[i] = color(32, 50, random(210, 230));
  }
  tracks.updatePixels();
}

public void draw() {
  background(0xffE2F0C4);
  camera(width/2.0f, mouseY, mouseX, width/2.0f, height/2.0f, 0, 0, 1, 0);

  hint(ENABLE_DEPTH_TEST);
  noStroke();
  drawGround();

  plants.update();
  plants.draw();

  robots.run();

  for (int i = robots.particles.size()-1; i >= 0; i--) {
    Walker bot = robots.particles.get(i);
    if (bot.mode == Walker.MOVING) {
      darkenRobotTracks(bot);
    }
  }

  noLights();
  camera();
  hint(DISABLE_DEPTH_TEST);
  robots.drawEmos();
}

public void darkenRobotTracks(Walker bot) {
  tracks.loadPixels();
  for (int i=0; i<30; i++) {
    int x = (int)((bot.location.x / width) * tracks.width + random(-5, 5));
    int y = (int)((bot.location.y / height) * tracks.height + random(-5, 5));

    int which = x + y * tracks.width;
    if (which < 0) which = 0;
    if (which > tracks.pixels.length) which = tracks.pixels.length - 1;

    int c = tracks.pixels[which];
    c = color(hue(c), saturation(c), brightness(c) - 20);
    tracks.pixels[which] = c;  
  }
  tracks.updatePixels();
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
class Emo {
  PImage img;
  PVector pos;

  Emo() {
    load();
    pos = new PVector();
  }  

  public void load() {
    this.normal();
  }

  public void planter() {
    img = loadImage("planter" + nf(1 + PApplet.parseInt(random(9)), 3) + ".png");
  }

  public void normal() {
    img = loadImage("normal" + nf(1 + PApplet.parseInt(random(6)), 3) + ".png");
  }

  public void enraged() {
    img = loadImage("enraged" + nf(1 + PApplet.parseInt(random(6)), 3) + ".png");
  }

  public void setPos(float x, float y) {
    pos.x = x;
    pos.y = y;
  }
  public void draw() {
    image(img, pos.x + 20, pos.y - 50);
  }
}
// okay, let's have our dear robots be enraged when they are surrounded by trees

class Killer extends Walker {
  float hunting;
  float killing;

  float senseRadius;
  int tolerance;
  float rage;

  Killer(PVector l) {
    super(l);
    hunting = 50.0f;
    killing = 10.0f;
    senseRadius = random(36.0f, 48.0f);
    tolerance = PApplet.parseInt(random(4, 12));
    rage = 0.0f;
  }

  public void run() {
    super.run();
    enrage();
  }

  public void look() {
    // hit target, change walk
    if (location.dist(target) < 10.0f) {
      philander();
    }

    int index = -1;
    float nearest = hunting;
    int counter = 0;

    for (int i = plants.vegetation.size()-1; i >= 0; i--) {
      Plant prey = plants.vegetation.get(i);
      PVector preyLocation = new PVector(prey.x, prey.y);
      float distance = location.dist(preyLocation);
      if (distance < nearest) {
        index = i;
        nearest = distance;
      }

      if (distance < senseRadius)
        counter++;
    }

    if (counter > tolerance) {
      rage += random(80, 120);
    }

    if (!isAvoiding) {
      if (index != -1 && nearest < killing) {
        kill(index);
      } else if (index != -1) {
        hunt(index);
      } else {
        normal();
      }      
    }
  }

  // immakilla
  public void kill(int index) {
    Plant prey = plants.vegetation.get(index);
    target = new PVector(prey.x, prey.y);
    plants.vegetation.get(index).kill();
    philander();
  }

  // immahunta
  public void hunt(int index) {
    Plant prey = plants.vegetation.get(index);
    target = new PVector(prey.x, prey.y);
  }

  public void normal() {
    speed = 5;
  }

  public void emotion() {
    if (rage < 0.1f)
      emo.normal();
    else
      emo.enraged();
  }

  public void enrage() {
    if (rage < 0.1f) {
      rage = 0;
      rotationRate = 0.05f;
      speed = 5.0f;
      c = color(200, 200, 100);
    } else {
      rage -= 1.0f;
      rotationRate = 0.2f;
      speed *= 1.1f;
      speed = min(speed, random(8.4f, 9.2f));
      c = color(0, 255, 125);
    }
  }
}
class Particle {
  PVector location;
  PVector velocity;
  PVector acceleration;
  boolean isDead;

  Particle(PVector l) {
    acceleration = new PVector(0,0);
    velocity = new PVector(random(-1,1),random(-1,1));
    location = l.get();
    isDead = false;
  }

  public void run() {
    update();
    display();
  }

  // Method to update location
  public void update() {
    velocity.add(acceleration);
    location.add(velocity);
  }

  // Method to display
  public void display() {
    stroke(100,255,255);
    pushMatrix();
      translate(location.x, location.y, location.z);
      // sphere(8);
      strokeWeight(8);
      point(0,0,0);
    popMatrix();
  }

  public void kill() {
    isDead = true;
  }
}
class ParticleSystem {

  ArrayList<Particle> particles;

  ParticleSystem(int num) {
    particles = new ArrayList<Particle>();
    for (int i = 0; i < num; i++) {
      this.addParticle();
    }
  }

  public void run() {
    for (int i = particles.size()-1; i >= 0; i--) {
      Particle p = particles.get(i);
      p.run();
      if (p.isDead) {
        particles.remove(i);
      }
    }
  }

  // roll of the dice for birth
  public void birth() {
    if (random(0,1) < 0.05f) {
      this.addParticle();
    }
  }

  // generate possible tank
  public void addParticle() {
    PVector location = new PVector(random(0, width), random(0, height));
    Particle p = new Particle(location);
    particles.add(p);
  }

  public void addParticle(Particle p) {
    particles.add(p);
  }
}
class Plant 
{ 

  float x, y; // positions
  float px, py; // parent position
  float age; // in seconds
  float size, size_min, size_max;
  float growth_rate;
  float time_born;
  boolean fully_grown, can_spawn;
  int generation;
  int hue, saturation, value;
  boolean isDead;

  public Plant(float x, float y, float px, float py, int hue, int generation)
  {
    this.x = x;
    this.y = y;
    this.px = px;
    this.py = py;    
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

    isDead = false;
  }

  public void draw()
  {
    
    pushMatrix();
    noStroke();
    lights();
      fill(this.hue, this.value, this.saturation);
    translate(this.x, this.y, 0);
    sphereDetail(10);
    sphere( this.size/2.0f );
    popMatrix();
    
    stroke(10,255,128);
    strokeWeight( this.size/this.size_max * 6.0f);
    line(this.px, this.py, 0, this.x, this.y, 0);
    noStroke();
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

  public void kill() {
    isDead = true;
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
    Plant root = new Plant(x, y, x,y, PApplet.parseInt(random(80,130)), 0);
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
    // yang: iterating backwards so we can kill plants
    for (int p = vegetation.size()-1; p >= 0; p--) {
      Plant plant = vegetation.get(p);
      plant.update(0);
      if (plant.isDead) {
        vegetation.remove(p);
      }
    }

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
            Plant sapling = new Plant(sx, sy, plant.x, plant.y, plant.hue, plant.generation+1);
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

class Planter extends Walker {

  Planter(PVector l) {
    super(l);
    speed = 2.0f;
    c = color(0);
  }

  public void run() {
    super.run();
    layseed();
  }

  public void layseed() {
    if (random(0, 1) < 0.02f)
      plants.seed_plant(location.x, location.y);
  }

  public void emotion() {
    emo.planter();
  }
}
class Robots {
  ArrayList<Walker> particles;

  Robots(int p, int k) {
    particles = new ArrayList<Walker>();
    for (int i = 0; i < p; i++) {
      this.addPlanter();
    }
    for (int i = 0; i < k; i++) {
      this.addParticle();
    }
  }

  public void run() {
    for (int i = particles.size()-1; i >= 0; i--) {
      Walker p = particles.get(i);
      p.run();
      if (p.isDead) { particles.remove(i); }
    }
    this.collisions();
  }

  public void collisions() {
    for (int i = this.particles.size()-1; i >= 0 ; i--) {
      Walker robot = this.particles.get(i);
      float avoidance = robot.avoidance;

      for (int j = this.particles.size()-1; j >= 0; j--) {
        Walker other = robots.particles.get(j);
        float distance = robot.location.dist(other.location);
        if (distance < avoidance && distance != 0) {

          // run in the opposite direction
          PVector opposite = robot.location.get();
          opposite.sub(other.location);
          opposite.normalize();
          opposite.mult(avoidance);
          opposite.add(robot.location);

          robot.isAvoiding = true;
          robot.target = opposite;
        }
      }
    }
  }

  // roll of the dice for birth
  public void birth() {
    if (random(0,1) < 0.001f) {
      this.addParticle();
    }
  }

  // generate possible tank
  public void addParticle() {
    PVector location = new PVector(random(0, width), random(0, height));
    Walker p = new Killer(location);
    particles.add(p);
  }

  public void addPlanter() {
    PVector location = new PVector(random(0, width), random(0, height));
    Walker p = new Planter(location);
    particles.add(p);
  }

  public void drawEmos() {
    for (int i = this.particles.size()-1; i >= 0; i--) {
      this.particles.get(i).emo.draw();
    }
  }
}
class Walker extends Particle {
  public static final int STILL = 0;
  public static final int MOVING = 1;
  public static final int ROTATING = 2;

  PVector target;
  float sz, dir, speed;
  float rotationRate;
  int c;
  int mode;
  Emo emo;

  // stuff for avoidance
  boolean isAvoiding;
  float avoidance;

  Walker(PVector l) {
    super(l);
    target = new PVector(random(0, width), random(0, height));
    sz = 20;
    speed = 5;
    dir = 0;
    c = color(200, 200, 100);
    rotationRate = 0.05f;
    isAvoiding = false;
    avoidance = random(30.0f, 40.0f);

    emo = new Emo();
    this.emotion();

    mode = STILL;
  }

  public void run() {
    update();
    look();
    display();
  }

  // Method to update location
  public void update() {
    if (location.dist(target) < 1) {
      return;
    }

    float tdir = atan2(target.y - location.y, target.x - location.x);
    float dirDiff = tdir - dir;
    PVector pDiff = PVector.sub(target, location);

    if (abs(dirDiff) < rotationRate) {
      dir = tdir;
      if (pDiff.mag() > speed) {
        // move
        pDiff.normalize();
        pDiff.mult(speed);
        location.add(pDiff);
        mode = MOVING;
      }
      else {
        mode = STILL;
      }
    } else {
      // rotate
      dir += dirDiff > 0 ? rotationRate : -rotationRate;
      mode = ROTATING;
    }
  }

  public void look() {
    if (location.dist(target) < 10.0f) {
      philander();
    }
  }

  public void philander() {
    target.x = random(0, width);
    target.y = random(0, height);
    isAvoiding = false;

    this.emotion();
    mode = STILL;
  }

  public void emotion() {
    emo.load();
  }

  public void display() {
    noStroke();
    
    pushMatrix();
    translate(location.x, location.y);
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
}
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "botsBehaviour" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
