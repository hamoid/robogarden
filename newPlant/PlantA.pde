class PlantA {
  Leaf[] leaves;
  float x, y;
  PlantA(float x, float y) {
    this.x = x;
    this.y = y;
    leaves = new Leaf[int(random(3, 6))];
    for(int i=0; i<leaves.length; i++) {
      leaves[i] = new Leaf(color(x % 256, 200, 200));
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
