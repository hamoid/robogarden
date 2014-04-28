class PlantA extends Plant {
  Leaf[] leaves;

  PlantA(float x, float y) {
    super(x,y, x,y, 0, 0);
    init();
  }
    // Copy constructor increments generation
  public PlantA (PlantA src) {
    super(src.x, src.y, src.px, src.py, src.hue, src.generation + 1);
    init();
  }
 
  void init(){
    leaves = new Leaf[int(random(2, 6))];
    color plantColor = color(random(256), random(256), 200);
    for(int i=0; i<leaves.length; i++) {
      leaves[i] = new Leaf(colorVariation(plantColor, 0.2));
    }
  }
  void draw() {
    pushMatrix();
    translate(x, y);
    rotateX(-PI/2.0);
    scale(0.2);
    
    for(int i=0; i<leaves.length; i++) {
      leaves[i].draw(int(this.age*5.0));
    }
    popMatrix();
  }
}

/*
  Note: vertices which are part of a PShape can be modified
  using getVertex() and setVertex()
  http://processing.org/reference/javadoc/core/
  
  This means we can make the plant shake, fall apart as a skyscraper, etc.
*/
class Leaf {
  int maxSteps;
  PVector[] a, b;
  color c1, c2;
  PShape obj3D;
  Leaf(color c1) {
    maxSteps = (int)random(50, 100);
    a = new PVector[maxSteps];
    b = new PVector[maxSteps];
    this.c1 = c1;
    this.c2 = colorVariation(c1, 0.3);
    obj3D = createShape();
    buildPlant();
  }
  private void buildPlant() {
    float id = random(999999);
    float pwidth = 20;
    float vstep = 10;
    float pheight = 0;
    PVector offset = new PVector(0, 0, 0);
    float angle = random(TAU);  
    float vstepDelta = random(0.2);

    for (int i=0; i<maxSteps; i++) {
      pheight -= vstep;
      vstep -= vstepDelta;
      pwidth += (noise(199, id, i * 0.2)-0.5)*5.0;
      angle += (noise(0, id, i * 0.2)-0.5)*0.4;
      offset.add(new PVector(
      map(noise(i * 0.1, id), 0, 1, -5, 5), 
      map(noise(0, i * 0.1, id), 0, 1, -5, 5)));
      float realWidth = 1 + (1 + sin(TAU * i / (float) maxSteps - HALF_PI)) * pwidth;
      a[i] = new PVector(-realWidth*cos(angle) + offset.x, pheight, realWidth*sin(angle) + offset.y);
      b[i] = new PVector(realWidth*cos(angle) + offset.x, pheight, -realWidth*sin(angle) + offset.y);
    }
  }
  void draw(int age) {
    if (age >= maxSteps) {
      shape(obj3D);
    } 
    else  {
      obj3D.beginShape(TRIANGLE_STRIP);
      obj3D.noStroke();
      obj3D.fill(lerpColor(c1, c2, age/(float)maxSteps));
      obj3D.vertex(a[age].x, a[age].y, a[age].z);
      obj3D.vertex(b[age].x, b[age].y, b[age].z);
      obj3D.endShape();
      shape(obj3D);
    } 
  }
}

color colorVariation(color c, float delta) {
  return color(
  hue(c)*random(1-delta, 1+delta), 
  saturation(c)*random(1-delta, 1+delta), 
  brightness(c)*random(1-delta, 1+delta)
    );
}

