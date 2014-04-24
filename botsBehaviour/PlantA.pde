class PlantA extends Plant {

  PlantA() {
    this(0, 0, 0, 0, 0, 0);
  }
  PlantA (float x, float y, float px, float py, int hue, int generation) {
    super(x, y, px, py, hue, generation);
  }
  void draw() {

    pushMatrix();
    noStroke();
    lights();
    fill(this.hue, this.value, this.saturation);
    translate(this.x, this.y, 0);
    sphereDetail(10);
    box( this.size/2.0 );
    popMatrix();

    //stroke(10,255,128);
    //strokeWeight( this.size/this.size_max * 6.0);
    //line(this.px, this.py, 0, this.x, this.y, 0);
    ///noStroke();
  }
  Plant clone() {
    Plant n = new PlantA();
    copyProperties(n);
    return n;
  }
}

