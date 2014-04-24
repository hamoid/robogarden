class Robots {
  ArrayList<Walker> particles;

  Robots(int p, int k) {
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
      if (p.isDead) { particles.remove(i); }
    }
    this.collisions();
  }

  void collisions() {
    for (int i = this.particles.size()-1; i >= 0 ; i--) {
      Walker robot = this.particles.get(i);
      float avoidance = robot.avoidance;

      for (int j = this.particles.size()-1; j >= 0; j--) {
        Walker other = robots.particles.get(j);
        float distance = robot.location.dist(other.location);
        if (distance < avoidance && distance != 0) {

          // run in the opposite direction
          PVector opposite = robot.location.get();
          opposite.sub(other.location);
          opposite.normalize();
          opposite.mult(avoidance);
          opposite.add(robot.location);

          robot.isAvoiding = true;
          robot.target = opposite;
        }
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
    for (int i = this.particles.size()-1; i >= 0; i--) {
      this.particles.get(i).emo.draw();
    }
  }
}