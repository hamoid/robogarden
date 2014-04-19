class Killer extends Walker {
  float hunting;
  float killing;

  Killer(PVector l) {
    super(l);
    hunting = 50.0;
    killing = 10.0;
  }

  void look() {
    // hit target, change walk
    if (location.dist(target) < 10.0) {
      philander();
    }

    int index = -1;
    float distance = hunting;

    for (int i = preys.particles.size()-1; i >= 0; i--) {
      Particle prey = preys.particles.get(i);
      if (location.dist(prey.location) < distance) {
        index = i;
        distance = location.dist(prey.location);
      }
    }

    if (!isAvoiding) {
      if (index != -1 && distance < killing) {
        kill(index);
      } else if (index != -1) {
        hunt(index);
      } else {
        normal();
      }      
    }
  }

  // immakilla
  void kill(int index) {
    target = preys.particles.get(index).location;
    preys.particles.get(index).kill();
    // debug
    stroke(255,0,0);
    line(location.x, location.y, target.x, target.y);
    philander();
  }

  // immahunta
  void hunt(int index) {
    target = preys.particles.get(index).location;
    // debug
    strokeWeight(1);
    stroke(255, 100);
    line(location.x, location.y, target.x, target.y);
  }

  void normal() {
    speed = 5;
  }
}