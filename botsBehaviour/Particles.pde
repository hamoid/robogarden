class ParticleSystem {

  ArrayList<Particle> particles;

  ParticleSystem(int num) {
    particles = new ArrayList<Particle>();
    for (int i = 0; i < num; i++) {
      this.addParticle();
    }
  }

  void run() {
    for (int i = particles.size()-1; i >= 0; i--) {
      Particle p = particles.get(i);
      p.run();
      if (p.isDead) {
        particles.remove(i);
      }
    }
  }

  // roll of the dice for birth
  void birth() {
    if (random(0,1) < 0.05) {
      this.addParticle();
    }
  }

  // generate possible tank
  void addParticle() {
    Particle p;
    PVector location = new PVector(random(0, width), random(0, height));
    if (random(0, 1) < 0.1) {
      p = new Walker(location);
    } else {
      p = new Particle(location);
    }
    particles.add(p);
  }

  void addParticle(Particle p) {
    particles.add(p);
  }
}