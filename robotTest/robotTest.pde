Robot r;
void setup() {
  size(800, 600, P3D);
  colorMode(HSB);
  background(255);
  rectMode(CENTER);

  r = new Robot(width/2, height/2);
  
  println("Press space to assign new destination");
}
void draw() {
  background(255);

  camera();
  r.emo.draw();

  camera(width/2.0, height * 1.5, (height*0.45) / tan(PI*30.0 / 180.0), width/2.0, height/2.0, 0, 0, 1, 0);
 
  fill(#F5EED5);
  rect(width/2, height/2, width, height);
  
  r.update();
  r.draw();  
}
void keyPressed() {
  if(key == ' ') {
    r.setRandomTarget();
  }
}
