class AggroKiller extends Killer {
  float maxSpeed;

  AggroKiller(PVector l) {
    super(l);
    hunting = random(50.0, 72.0);
    maxSpeed = random(2.8, 3.6);
  }

  // immahunta
  void hunt(int index) {
    target = preys.particles.get(index).location;
    speed *= 1.1;
    speed = min(speed, random(2.8, 3.6));
    // debug
    stroke(255);
    line(location.x, location.y, target.x, target.y);
  }

  void display() {
    stroke(255,128,0);
    ellipse(location.x,location.y,8,8);
  }
}