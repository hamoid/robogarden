class Leaf {
  int maxSteps;
  PVector[] a, b;
  color c1, c2;
  Leaf(color c1) {
    maxSteps = (int)random(50, 200);
    a = new PVector[maxSteps];
    b = new PVector[maxSteps];
    this.c1 = c1;
    this.c2 = colorVariation(c1, 0.2);
    buildPlant();
  }
  private void buildPlant() {
    float id = random(999999);
    float pwidth = 20;
    float vstep = 5;
    float pheight = 0;
    PVector offset = new PVector(0, 0, 0);
    float angle = random(TAU);  
    float vstepDelta = random(0.1);

    for (int i=0; i<maxSteps; i++) {
      pheight -= vstep;
      vstep -= vstepDelta;
      pwidth += (noise(199, id, i * 0.2)-0.5)*10.0;
      angle += (noise(0, id, i * 0.2)-0.5)*0.2;
      offset.add(new PVector(
      map(noise(i * 0.1, id), 0, 1, -5, 5), 
      map(noise(0, i * 0.1, id), 0, 1, -5, 5)));
      float realWidth = 0.1 + (1 + sin(TAU * i / (float) maxSteps - HALF_PI)) * pwidth;
      a[i] = new PVector(-realWidth*cos(angle) + offset.x, pheight, realWidth*sin(angle) + offset.y);
      b[i] = new PVector(realWidth*cos(angle) + offset.x, pheight, -realWidth*sin(angle) + offset.y);
    }
  }
  void draw() {
    beginShape(TRIANGLE_STRIP);
    int frame = min(frameCount, maxSteps);
    for (int i=0; i<frame; i++) {
      fill(lerpColor(c1, c2, i/(float)frame));
      vertex(a[i].x, a[i].y, a[i].z);
      vertex(b[i].x, b[i].y, b[i].z);
    }
    endShape();
  }
}

