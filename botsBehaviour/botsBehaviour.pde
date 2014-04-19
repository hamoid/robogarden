Predators predators;
Preys preys;

void setup() {
  size(800, 600, P3D);
  colorMode(HSB);
  background(255);
  noFill();
  stroke(255);

  predators = new Predators(6);
  preys = new Preys(0);
}

void draw() {
  background(255);
  // camera(width/2.0, height * 2, (height/4.0) / tan(PI*30.0 / 180.0), width/2.0, height/2.0, 0, 0, 1, 0); 


  // predators.birth();
  preys.birth();
  predators.run();
  preys.run();
}