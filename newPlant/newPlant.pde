PlantA a, b, c;
void setup() {
  size(600, 600, P3D);
  colorMode(HSB);
  a = new PlantA(width*0.3, height);
  b = new PlantA(width*0.6, height);
  c = new PlantA(width*0.9, height);
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

