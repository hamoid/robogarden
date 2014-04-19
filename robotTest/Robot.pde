class Robot {
  PVector pos, tpos;
  float sz, dir, speed;
  color c;
  Emo emo;

  Robot(float x, float y) {
    pos = new PVector(x, y);
    tpos = new PVector(x, y); 
    this.dir = 0;
    this.sz = 40;
    this.speed = 5;
    c = color(random(255), 200, 100);
    
    emo = new Emo();
  }

  void draw() {
    noStroke();
    
    pushMatrix();
    translate(pos.x, pos.y);
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
  void update() {
    if (pos.dist(tpos) < 1) {
      return;
    }

    float tdir = atan2(tpos.y - pos.y, tpos.x - pos.x);
    float dirDiff = tdir - dir;
    PVector pDiff = PVector.sub(tpos, pos);

    if (abs(dirDiff) < 0.05) {
      dir = tdir;
      if (pDiff.mag() > 5) {
        // move
        pDiff.normalize();
        pDiff.mult(5);
        pos.add(pDiff);
      }
    } else {
      // rotate
      dir += dirDiff > 0 ? 0.05 : -0.05;
    }
  }

  void setRandomTarget() {
    tpos.x = random(width);
    tpos.y = random(height);
    emo.load();
  }
}

