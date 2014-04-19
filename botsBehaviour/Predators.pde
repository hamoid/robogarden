class Predators extends ParticleSystem {
  Predators(int num) {
    super(num);
  }

  // roll of the dice for birth
  void birth() {
    if (random(0,1) < 0.001) {
      this.addParticle();
    }
  }

  // generate possible tank
  void addParticle() {
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