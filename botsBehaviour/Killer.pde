// okay, let's have our dear robots be enraged when they are surrounded by trees

class Killer extends Walker {
  float hunting;
  float killing;

  float senseRadius;
  int tolerance;
  float rage;

  Killer(PVector l) {
    super(l);
    hunting = 50.0;
    killing = 10.0;
    senseRadius = random(36.0, 48.0);
    tolerance = int(random(4, 12));
    rage = 0.0;
  }

  void run() {
    super.run();
    mood();
  }

  void look() {
    // hit target, change walk
    if (location.dist(target) < 10.0) {
      philander();
    }

    int index = -1;
    float nearest = hunting;
    int counter = 0;

    for (int i = preys.particles.size()-1; i >= 0; i--) {
      Particle prey = preys.particles.get(i);
      float distance = location.dist(prey.location);
      if (distance < nearest) {
        index = i;
        nearest = distance;
      }

      if (distance < senseRadius)
        counter++;
    }

    if (counter > tolerance) {
      rage += random(80, 120);
    }

    if (!isAvoiding) {
      if (index != -1 && nearest < killing) {
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

  void mood() {
    if (rage < 0.1) {
      rage = 0;
      rotationRate = 0.05;
      speed = 5.0;
      c = color(0, 200, 100);
    } else {
      rage -= 1.0;
      rotationRate = 0.2;
      speed *= 1.1;
      speed = min(speed, random(8.4, 9.2));
      c = color(100, 255, 125);
    }
  }
}