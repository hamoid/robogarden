class PlantA {
  Leaf[] leaves;
  float x, y;
  PlantA(float x, float y) {
    this.x = x;
    this.y = y;
    leaves = new Leaf[int(random(2, 6))];
    color plantColor = color(random(256), random(256), 200);
    for(int i=0; i<leaves.length; i++) {
      leaves[i] = new Leaf(colorVariation(plantColor, 0.2));
    }
  }
  void draw() {
    pushMatrix();
    translate(x, y);
    rotateY(-mouseX * 0.01);
    
    for(int i=0; i<leaves.length; i++) {
      leaves[i].draw(frameCount);
    }
    popMatrix();
  }
}
