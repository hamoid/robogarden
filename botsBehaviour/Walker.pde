class Walker extends Particle {
  PVector target;
  float speed;

  Walker(PVector l) {
    super(l);
    target = new PVector(random(0, width), random(0, height));
    speed = 1.0;
  }

  void run() {
    update();
    look();
    display();
  }

  // Method to update location
  void update() {
    PVector l = location.get();
    PVector d = target.get();
    d.sub(l);
    d.normalize();
    acceleration = d;

    velocity.add(acceleration);
    velocity.normalize();
    velocity.mult(speed);
    location.add(velocity);

    acceleration.x = 0;
    acceleration.y = 0;
  }

  void look() {
    if (location.dist(target) < 10.0) {
      philander();
    }
  }

  void philander() {
    target.x = random(0, width);
    target.y = random(0, height);
  }

  void display() {
    stroke(255, 0, 0);
    ellipse(location.x,location.y,8,8);
  }
}