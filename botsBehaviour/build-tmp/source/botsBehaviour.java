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

Predators predators;
Preys preys;

public void setup() {
  size(800, 600, P3D);
  colorMode(HSB);
  background(255);
  noFill();
  stroke(255);

  predators = new Predators(6);
  preys = new Preys(0);
}

public void draw() {
  background(255);
  // camera(width/2.0, height * 2, (height/4.0) / tan(PI*30.0 / 180.0), width/2.0, height/2.0, 0, 0, 1, 0); 


  // predators.birth();
  preys.birth();
  predators.run();
  preys.run();
}
class AggroKiller extends Killer {
  float maxSpeed;

  AggroKiller(PVector l) {
    super(l);
    hunting = random(50.0f, 72.0f);
    maxSpeed = random(2.8f, 3.6f);
    c = color(100, 200, 100);
    rotationRate = 0.2f;
  }

  // immahunta
  public void hunt(int index) {
    target = preys.particles.get(index).location;
    speed *= 1.1f;
    speed = min(speed, random(2.8f, 3.6f));
    // debug
    strokeWeight(1);
    stroke(255, 100);
    line(location.x, location.y, target.x, target.y);
  }
}
class BombKiller extends Killer {
  float senseRadius;
  float bombRadius;
  int tolerance;

  BombKiller(PVector l) {
    super(l);
    speed = 0.3f;
    senseRadius = random(36.0f, 48.0f);
    bombRadius = random(36.0f, 48.0f);
    tolerance = PApplet.parseInt(random(15, 20));
    c = color(200, 200, 100);
  }

  public void run() {
    update();
    look();
    display();
  }

  public void look() {
    if (location.dist(target) < 10.0f) {
      philander();
    }

    int counter = 0;
    for (int i = preys.particles.size()-1; i >= 0; i--) {
      Particle prey = preys.particles.get(i);
      if (location.dist(prey.location) < senseRadius)
        counter++;
    }

    if (counter > tolerance)
      kill();
  }

  // i dont hunt.
  // void hunt() {}

  public void kill() {
    for (int i = preys.particles.size()-1; i >= 0; i--) {
      Particle prey = preys.particles.get(i);
      if (location.dist(prey.location) < bombRadius)
        prey.kill();
    }

    // debug
    stroke(0,255,255);
    ellipse(location.x, location.y, bombRadius, bombRadius);
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
    mood();
  }

  public void look() {
    // hit target, change walk
    if (location.dist(target) < 10.0f) {
      philander();
    }

    int index = -1;
    float nearest = hunting;
    int counter = 0;

    for (int i = preys.particles.size()-1; i >= 0; i--) {
      Particle prey = preys.particles.get(i);
      float distance = location.dist(prey.location);
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
    target = preys.particles.get(index).location;
    preys.particles.get(index).kill();
    // debug
    stroke(255,0,0);
    line(location.x, location.y, target.x, target.y);
    philander();
  }

  // immahunta
  public void hunt(int index) {
    target = preys.particles.get(index).location;
    // debug
    strokeWeight(1);
    stroke(255, 100);
    line(location.x, location.y, target.x, target.y);
  }

  public void normal() {
    speed = 5;
  }

  public void mood() {
    if (rage < 0.1f) {
      rage = 0;
      rotationRate = 0.05f;
      speed = 5.0f;
      c = color(0, 200, 100);
    } else {
      rage -= 1.0f;
      rotationRate = 0.2f;
      speed *= 1.1f;
      speed = min(speed, random(8.4f, 9.2f));
      c = color(100, 255, 125);
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
    Particle p;
    PVector location = new PVector(random(0, width), random(0, height));
    if (random(0, 1) < 0.1f) {
      p = new Walker(location);
    } else {
      p = new Particle(location);
    }
    particles.add(p);
  }

  public void addParticle(Particle p) {
    particles.add(p);
  }
}
class Plant extends Particle {
  float range;

  Plant(PVector l) {
    super(l);
    velocity.x = 0;
    velocity.y = 0;
    range = random(10, 12);
  }

  public void run() {
    update();
    grow();
    display();
  }

  public void grow() {
    if (random(0, 1) < 0.0005f) {
      sprout();
    }
  }

  public void sprout() {
    float angle = random(0, 1) * TWO_PI;
    float radius = random(0, range);
    PVector spawn = new PVector(location.x+sin(angle)*radius, location.y+cos(angle)*radius);
    preys.addParticle(new Plant(spawn));

    // debug
    stroke(0,255,0);
    line(location.x, location.y, spawn.x, spawn.y);
  }
}
class Predators extends ParticleSystem {
  Predators(int num) {
    super(num);
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
    Particle p;

    // if (random(0, 1) < 0.5)
    //   p = new AggroKiller(location);
    // // else if (random(0, 1) < 0.22)
    // //   p = new BombKiller(location);
    // else
      p = new Killer(location);
    particles.add(p);
  }
}
class Preys extends ParticleSystem {
  Preys(int num) {
    super(num);
  }
  // roll of the dice for birth
  public void birth() {
    if (random(0,1) < 0.05f) {
      this.addParticle();
    }
  }

  public void addParticle() {
    float angle = random(0, 1) * TWO_PI;
    float radius = random(0, width/2);
    PVector location = new PVector(width/2+sin(angle)*radius, height/2+cos(angle)*radius);
    Particle p = new Plant(location);
    particles.add(p);
  }
}
class Walker extends Particle {
  PVector target;
  float sz, dir, speed;
  float rotationRate;
  int c;

  // stuff for avoidance
  boolean isAvoiding;
  float avoidance;

  Walker(PVector l) {
    super(l);
    target = new PVector(random(0, width), random(0, height));
    sz = 20;
    speed = 5;
    dir = 0;
    c = color(0, 200, 100);
    rotationRate = 0.05f;
    isAvoiding = false;
    avoidance = random(30.0f, 40.0f);
  }

  public void run() {
    update();
    look();
    avoid();
    display();
  }

  // Method to update location
  public void update() {
    // PVector l = location.get();
    // PVector d = target.get();
    // d.sub(l);
    // d.normalize();
    // acceleration = d;

    // velocity.add(acceleration);
    // velocity.normalize();
    // velocity.mult(speed);
    // location.add(velocity);

    // acceleration.x = 0;
    // acceleration.y = 0;

    if (location.dist(target) < 1) {
      return;
    }

    float tdir = atan2(target.y - location.y, target.x - location.x);
    float dirDiff = tdir - dir;
    PVector pDiff = PVector.sub(target, location);

    if (abs(dirDiff) < rotationRate) {
      dir = tdir;
      if (pDiff.mag() > 5) {
        // move
        pDiff.normalize();
        pDiff.mult(5);
        location.add(pDiff);
      }
    } else {
      // rotate
      dir += dirDiff > 0 ? rotationRate : -rotationRate;
    }
  }

  public void look() {
    if (location.dist(target) < 10.0f) {
      philander();
    }
  }

  public void avoid() {
    for (int i = predators.particles.size()-1; i >= 0; i--) {
      Particle other = predators.particles.get(i);
      float distance = location.dist(other.location);
      if (distance < avoidance && distance != 0) {
        isAvoiding = true;

        // run in the opposite direction
        PVector opposite = location.get();
        opposite.sub(other.location);
        opposite.normalize();
        opposite.mult(avoidance);
        opposite.add(location);
        target = opposite;
      }
    }
  }

  public void philander() {
    target.x = random(0, width);
    target.y = random(0, height);
    isAvoiding = false;
  }

  public void display() {
    rectMode(CENTER);
    noStroke();
    
    pushMatrix();
    translate(location.x, location.y);
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
