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
    enrage();
  }

  void look() {
    // hit target, change walk
    if (location.dist(target) < 10.0) {
      philander();
    }

    int index = -1;
    float nearest = hunting;
    int counter = 0;

    for (int i = plants.vegetation.size()-1; i >= 0; i--) {
      Plant prey = plants.vegetation.get(i);
      PVector preyLocation = new PVector(prey.x, prey.y);
      float distance = location.dist(preyLocation);
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
    Plant prey = plants.vegetation.get(index);
    target = new PVector(prey.x, prey.y);
    plants.vegetation.get(index).kill();
    philander();
  }

  // immahunta
  void hunt(int index) {
    Plant prey = plants.vegetation.get(index);
    target = new PVector(prey.x, prey.y);
  }

  void normal() {
    speed = 5;
  }

  void emotion() {
    if (rage < 0.1)
      emo.normal();
    else
      emo.enraged();
  }

  void enrage() {
    if (rage < 0.1) {
      rage = 0;
      rotationRate = 0.05;
      speed = 5.0;
      c = color(200, 200, 100);
    } else {
      rage -= 1.0;
      rotationRate = 0.2;
      speed *= 1.1;
      speed = min(speed, random(8.4, 9.2));
      c = color(0, 255, 125);
    }
  }
}