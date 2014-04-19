Robot r;
void setup() {
  size(800, 600, P3D);
  colorMode(HSB);
  background(255);
  
  r = new Robot(width/2, height/2);
  
  println("Press space to assign new destination");
}
void draw() {
  background(255);
  camera(width/2.0, height * 2, (height/4.0) / tan(PI*30.0 / 180.0), width/2.0, height/2.0, 0, 0, 1, 0); 
  
  r.update();
  r.draw();
}
void keyPressed() {
  if(key == ' ') {
    r.setRandomTarget();
  }
}
