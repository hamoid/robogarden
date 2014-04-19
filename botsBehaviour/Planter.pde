class Planter extends Walker {

  Planter(PVector l) {
    super(l);
    speed = 2.0;
    c = color(0);
  }

  void run() {
    update();
    look();
    avoid();
    layseed();
    display();
  }

  void layseed() {
    if (random(0, 1) < 0.02)
      plants.seed_plant(location.x, location.y);
  }

  void philander() {
    target.x = random(0, width);
    target.y = random(0, height);
    isAvoiding = false;
    emo.load();
  }
}