PlantA a, b, c;
void setup() {
  size(600, 800, P3D);
  colorMode(HSB);
  a = new PlantA(width*0.25, height*0.9);
  b = new PlantA(width*0.5, height*0.9);
  c = new PlantA(width*0.75, height*0.9);
}
void draw() {
  background(255);
  lights();
  noStroke();
  a.draw();
  b.draw();
  c.draw();
}
color colorVariation(color c, float delta) {
  return color(
  hue(c)*random(1-delta, 1+delta), 
  saturation(c)*random(1-delta, 1+delta), 
  brightness(c)*random(1-delta, 1+delta)
    );
}

