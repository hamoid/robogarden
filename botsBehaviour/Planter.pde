class Planter extends Walker {

  Planter(PVector l) {
    super(l);
    speed = 2.0;
    c = color(0);
  }

  void run() {
    super.run();
    layseed();
  }

  void layseed() {
    if (random(0, 1) < 0.02)
      plants.seed_plant(location.x, location.y, int(random(2)));
  }

  void emotion() {
    emo.planter();
  }
}
