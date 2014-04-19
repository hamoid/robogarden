class Predators {
  ArrayList<Walker> particles;

  Predators(int p, int k) {
    particles = new ArrayList<Walker>();
    for (int i = 0; i < p; i++) {
      this.addPlanter();
    }
    for (int i = 0; i < k; i++) {
      this.addParticle();
    }
  }

  void run() {
    for (int i = particles.size()-1; i >= 0; i--) {
      Walker p = particles.get(i);
      p.run();
      if (p.isDead) {
        particles.remove(i);
      }
    }
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
    Walker p = new Killer(location);
    particles.add(p);
  }

  void addPlanter() {
    PVector location = new PVector(random(0, width), random(0, height));
    Walker p = new Planter(location);
    particles.add(p);
  }

  void drawEmos() {
    for (int i = predators.particles.size()-1; i >= 0; i--) {
      predators.particles.get(i).emo.draw();
    }
  }
}