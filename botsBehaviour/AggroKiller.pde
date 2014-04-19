class AggroKiller extends Killer {
  float maxSpeed;

  AggroKiller(PVector l) {
    super(l);
    hunting = random(50.0, 72.0);
    maxSpeed = random(2.8, 3.6);
    c = color(100, 200, 100);
    rotationRate = 0.2;
  }

  // immahunta
  void hunt(int index) {
    target = preys.particles.get(index).location;
    speed *= 1.1;
    speed = min(speed, random(2.8, 3.6));
    // debug
    strokeWeight(1);
    stroke(255, 100);
    line(location.x, location.y, target.x, target.y);
  }
}