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
    stroke(100,255,255);
    pushMatrix();
      translate(location.x, location.y, location.z);
      // sphere(8);
      strokeWeight(8);
      point(0,0,0);
    popMatrix();
  }

  void kill() {
    isDead = true;
  }
}