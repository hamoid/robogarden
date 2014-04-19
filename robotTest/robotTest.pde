Robot r;
//Plant p;
void setup() {
  size(800, 600, P3D);
  colorMode(HSB);
  background(255);
  rectMode(CENTER);

  r = new Robot(width/2, height/2);
  //p = new Plant(width/2, height/2);
  
  println("Press space to assign new destination");
}
void draw() {
  background(255);

  camera(width/2.0, height * 1.5, (height*0.45) / tan(PI*30.0 / 180.0), width/2.0, height/2.0, 0, 0, 1, 0);
  drawGround();
  r.update();
  r.draw();
  
  //p.draw();  

  camera();
  r.emo.draw();
}
void drawGround() {
  fill(#F5EED5);
  rect(width/2, height/2, width, height);  
}
void keyPressed() {
  if(key == ' ') {
    r.setRandomTarget();
  }
}
