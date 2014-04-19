class Walker extends Particle {
  PVector target;
  float sz, dir, speed;
  float rotationRate;
  color c;

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
    rotationRate = 0.05;
    isAvoiding = false;
    avoidance = random(30.0, 40.0);
  }

  void run() {
    update();
    look();
    avoid();
    display();
  }

  // Method to update location
  void update() {
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

  void look() {
    if (location.dist(target) < 10.0) {
      philander();
    }
  }

  void avoid() {
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

  void philander() {
    target.x = random(0, width);
    target.y = random(0, height);
    isAvoiding = false;
  }

  void display() {
    rectMode(CENTER);
    noStroke();
    
    pushMatrix();
    translate(location.x, location.y);
    scale(sz);
    rotate(dir);

    fill(c);

    box(1.0, 0.8, 0.1);

    pushMatrix();
    translate(0, 0.5);
    box(1.0, 0.1, 0.3);
    popMatrix();
    
    pushMatrix();
    translate(0, -0.5);
    box(1.0, 0.1, 0.3);
    popMatrix();

    fill(255);

    pushMatrix();
    translate(0.4, 0.2, 0.2);
    box(0.1);
    popMatrix();
    
    pushMatrix();
    translate(0.4, -0.2, 0.2);
    box(0.1);
    popMatrix();

    popMatrix();
  }
}