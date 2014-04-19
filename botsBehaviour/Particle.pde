class Particle {
  PVector location;
  PVector velocity;
  PVector acceleration;
  boolean isDead;

  Particle(PVector l) {
    acceleration = new PVector(0,0);
    velocity = new PVector(random(-1,1),random(-1,1));
    location = l.get();
    isDead = false;
  }

  void run() {
    update();
    display();
  }

  // Method to update location
  void update() {
    velocity.add(acceleration);
    location.add(velocity);
  }

  // Method to display
  void display() {
    stroke(255);
    ellipse(location.x,location.y,8,8);
  }

  void kill() {
    isDead = true;
  }
}