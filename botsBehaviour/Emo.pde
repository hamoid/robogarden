class Emo {
  PImage img;
  PVector pos;

  Emo() {
    load();
    pos = new PVector();
  }  

  void load() {
    this.normal();
  }

  void planter() {
    img = loadImage("planter" + nf(1 + int(random(9)), 3) + ".png");
  }

  void normal() {
    img = loadImage("normal" + nf(1 + int(random(6)), 3) + ".png");
  }

  void enraged() {
    img = loadImage("enraged" + nf(1 + int(random(6)), 3) + ".png");
  }

  void setPos(float x, float y) {
    pos.x = x;
    pos.y = y;
  }
  void draw() {
    image(img, pos.x + 20, pos.y - 50);
  }
}