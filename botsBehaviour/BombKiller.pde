class BombKiller extends Killer {
  float senseRadius;
  float bombRadius;
  int tolerance;

  BombKiller(PVector l) {
    super(l);
    speed = 0.3;
    senseRadius = random(36.0, 48.0);
    bombRadius = random(36.0, 48.0);
    tolerance = int(random(15, 20));
    c = color(200, 200, 100);
  }

  void run() {
    update();
    look();
    display();
  }

  void look() {
    if (location.dist(target) < 10.0) {
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

  void kill() {
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