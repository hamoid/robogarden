class Emo {
  PImage img;
  PVector pos;

  Emo() {
    load();
    pos = new PVector();
  }  
  void load() {
    img = loadImage("icon" + nf(1 + int(random(21)), 3) + ".png");
  }
  void setPos(float x, float y) {
    pos.x = x;
    pos.y = y;
  }
  void draw() {
    image(img, pos.x + 20, pos.y - 50);
  }
}
