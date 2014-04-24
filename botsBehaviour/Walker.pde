class Walker extends Particle {
  public static final int STILL = 0;
  public static final int MOVING = 1;
  public static final int ROTATING = 2;

  PVector target, pDiff;    // expose pDiff for drawing tracks, alternatively, encapulate tracks into Walker
  float sz, dir, speed;
  float rotationRate;
  color c;
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
    rotationRate = 0.05;
    isAvoiding = false;
    avoidance = random(30.0, 40.0);

    emo = new Emo();
    this.emotion();

    mode = STILL;
  }

  void run() {
    update();
    look();
    display();
  }

  // Method to update location
  void update() {
    if (location.dist(target) < 1) {
      return;
    }

    float tdir = atan2(target.y - location.y, target.x - location.x);
    float dirDiff = tdir - dir;
    pDiff = PVector.sub(target, location);

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

  void look() {
    if (location.dist(target) < 10.0) {
      philander();
    }
  }

  void philander() {
    target.x = random(0, width);
    target.y = random(0, height);
    isAvoiding = false;

    this.emotion();
    mode = STILL;
  }

  void emotion() {
    emo.load();
  }

  void display() {
    noStroke();
    
    pushMatrix();
    translate(location.x, location.y);
    scale(sz);
    rotate(dir);

    fill(c);

    box(1.0, 0.8, 0.1);

    emo.setPos(screenX(0, 0, 0), screenY(0, 0, 0));

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