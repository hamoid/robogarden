class Plant {
  private final int LEVELS = 50;
  PVector pos;
  int age;
  PShape[] plant;
  
  Plant(float x, float y) {
    pos = new PVector(x, y);
    age = 0;
    plant = new PShape[LEVELS];

    PVector posa = pos.get();
    PVector posb = pos.get();
    for(int i=0; i<LEVELS; i++) {
      posb = posa.get();
      posb.z += 10;
      plant[i] = createPrism(posa, posb);
      posa = posb.get();
    }
  }
  
  void draw() {
    for(int i=0; i<age; i++) {
      shape(plant[i]);
    }
    age = min(LEVELS, age + 1);
  }
  PShape createPrism(PVector a, PVector b) {
    float d = PVector.dist(a, b) * 0.5;
    float T3 = TAU / 3;
    PVector p1 = new PVector(b.x + d * cos(T3*1), b.y + d * sin(T3*1), b.z);
    PVector p2 = new PVector(b.x + d * cos(T3*2), b.y + d * sin(T3*2), b.z);
    PVector p3 = new PVector(b.x + d * cos(T3*3), b.y + d * sin(T3*3), b.z);
    PShape sh = createShape();
    sh.beginShape(TRIANGLES);
    sh.noStroke();
    sh.fill(random(100, 200));
    
    sh.vertex(p1.x, p1.y, p1.z);
    sh.vertex(p2.x, p2.y, p2.z);
    sh.vertex(p3.x, p3.y, p3.z);

    sh.vertex(p1.x, p1.y, p1.z);
    sh.vertex(p2.x, p2.y, p2.z);
    sh.vertex(a.x, a.y, a.z);

    sh.vertex(p2.x, p2.y, p2.z);
    sh.vertex(p3.x, p3.y, p3.z);
    sh.vertex(a.x, a.y, a.z);

    sh.vertex(p3.x, p3.y, p3.z);
    sh.vertex(p1.x, p1.y, p1.z);
    sh.vertex(a.x, a.y, a.z);
    
    sh.endShape();
    return sh;
  }
}
