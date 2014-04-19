class Plant extends Particle {
  float range;

  Plant(PVector l) {
    super(l);
    velocity.x = 0;
    velocity.y = 0;
    range = random(10, 12);
  }

  void run() {
    update();
    grow();
    display();
  }

  void grow() {
    if (random(0, 1) < 0.0005) {
      sprout();
    }
  }

  void sprout() {
    float angle = random(0, 1) * TWO_PI;
    float radius = random(0, range);
    PVector spawn = new PVector(location.x+sin(angle)*radius, location.y+cos(angle)*radius);
    preys.addParticle(new Plant(spawn));

    // debug
    stroke(0,255,0);
    line(location.x, location.y, spawn.x, spawn.y);
  }
}