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
class PlantA {
  Leaf[] leaves;
  float x, y;
  PlantA(float x, float y) {
    this.x = x;
    this.y = y;
    leaves = new Leaf[int(random(3, 6))];
    for(int i=0; i<leaves.length; i++) {
      leaves[i] = new Leaf();
    }
  }
  void draw() {
    pushMatrix();
    translate(x, y);
    rotateY(mouseX * 0.01);
    
    for(int i=0; i<leaves.length; i++) {
      leaves[i].draw();
    }
    popMatrix();
  }
}
class Leaf {
  int maxSteps;
  float id, baseAngle, vstepDelta;
  Leaf() {
    id = random(999999);
    baseAngle = random(TAU);
    vstepDelta = random(0.1);
    maxSteps = (int)random(50, 200);
  }
  void draw() {
    float pwidth = 20;
    float vstep = 5;
    float pheight = 0;
    PVector offset = new PVector(0, 0, 0);
    float angle = baseAngle;  
    beginShape(TRIANGLE_STRIP);
    int frame = min(frameCount, maxSteps);
    for (int i=0; i<frame; i++) {
      fill(map(i%30, 0, 30, 80, 120), 255, 255);
      pheight -= vstep;
      vstep -= vstepDelta;
      pwidth += (noise(199, id * 50, i * 0.2)-0.5)*10.0;
      angle += (noise(0, id * 50, i * 0.2)-0.5)*0.2;
      offset.add(new PVector(
      map(noise(i * 0.1, id * 50), 0, 1, -5, 5), 
      map(noise(0, i * 0.1, id * 50), 0, 1, -5, 5)));
      float realWidth = 0.1 + (1 + sin(TAU * i / (float) maxSteps - HALF_PI)) * pwidth;
      vertex(-realWidth*cos(angle) + offset.x, pheight, realWidth*sin(angle) + offset.y);
      vertex(realWidth*cos(angle) + offset.x, pheight, -realWidth*sin(angle) + offset.y);
    }
    endShape();
  }
}

