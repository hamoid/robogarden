Robot r;
//Plant3D p;
PlantGroup plants;

PImage tracks;

void setup() {
  size(800, 600, P3D);
  colorMode(HSB);
  background(255);
  rectMode(CENTER);

  r = new Robot(width/2, height/2);
  //p = new Plant3D(width/2, height/2);

  plants = new PlantGroup();

  tracks = createImage(1600, 1200, RGB);
  tracks.loadPixels();
  for (int i = 0; i < tracks.pixels.length; i++) {
    tracks.pixels[i] = color(32, 50, random(210, 230));
  }
  tracks.updatePixels();

  println("Press space to assign new destination");
}
void draw() {
  background(#E2F0C4);

  float camx = 200 * sin(frameCount * 0.001);
  float camy = 200 * cos(frameCount * 0.001);

  camera(
  r.pos.x, r.pos.y + height*0.5, height * 0.5, 
  r.pos.x + camx, r.pos.y + camy, r.pos.z, 
  0, 1, 0);
  hint(ENABLE_DEPTH_TEST);
  drawGround();
  r.update();
  r.draw();

  if (r.mode == Robot.MOVING) {
    darkenRobotTracks();
  }

  plants.update();
  plants.draw();

  //p.draw();  

  camera();
  hint(DISABLE_DEPTH_TEST);
  r.emo.draw();
}
void darkenRobotTracks() {
  tracks.loadPixels();
  for (int i=0; i<30; i++) {
    int x = (int)((r.pos.x / width) * tracks.width + random(-5, 5));
    int y = (int)((r.pos.y / height) * tracks.height + random(-5, 5));

    int which = x + y * tracks.width;
    if (which < 0) which = 0;
    if (which > tracks.pixels.length) which = tracks.pixels.length - 1;

    int c = tracks.pixels[which];
    c = color(hue(c), saturation(c), brightness(c) - 20);
    tracks.pixels[which] = c;  
  }
  tracks.updatePixels();
}
void drawGround() {
  beginShape();
  textureMode(NORMAL);
  texture(tracks);
  vertex(0, 0, 0, 0);
  vertex(width, 0, 1, 0);
  vertex(width, height, 1, 1);
  vertex(0, height, 0, 1);
  endShape();
}
void keyPressed() {
  if (key == ' ') {
    r.setRandomTarget();
  }
  if (key == 'p') {
    plants.seed_plant(r.pos.x, r.pos.y);
  }
}

