Predators predators;
Preys preys;

void setup() {
  size(640, 640);
  noFill();
  stroke(255);

  predators = new Predators(10);
  preys = new Preys(0);
}

void draw() {
  // background(0,0,0);
  noStroke();
  fill(0, 10);
  rect(0,0, width, height);

  // predators.birth();
  preys.birth();
  predators.run();
  preys.run();
}