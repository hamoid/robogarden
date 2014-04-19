class Preys extends ParticleSystem {
  Preys(int num) {
    super(num);
  }
  // roll of the dice for birth
  void birth() {
    if (random(0,1) < 0.05) {
      this.addParticle();
    }
  }

  void addParticle() {
    float angle = random(0, 1) * TWO_PI;
    float radius = random(0, width/2);
    PVector location = new PVector(width/2+sin(angle)*radius, height/2+cos(angle)*radius);
    Particle p = new Plant(location);
    particles.add(p);
  }
}