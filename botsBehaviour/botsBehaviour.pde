Predators predators;
Preys preys;
PlantGroup plants;
Walker planter;

PImage tracks;

void setup() {
  size(1344, 768, P3D);
  colorMode(HSB);
  background(255);
  noFill();
  rectMode(CENTER);

  predators = new Predators(1, 3);
  preys = new Preys(0);
  plants = new PlantGroup();

  planter = predators.particles.get(0);

  tracks = createImage(1600, 1200, RGB);
  tracks.loadPixels();
  for (int i = 0; i < tracks.pixels.length; i++) {
    tracks.pixels[i] = color(32, 50, random(210, 230));
  }
  tracks.updatePixels();
}

void draw() {
  background(#E2F0C4);
  camera(width/2.0, mouseY, mouseX, width/2.0, height/2.0, 0, 0, 1, 0);
  // camera(width/2.0, height * 2, (height/4.0) / tan(PI*30.0 / 180.0), width/2.0, height/2.0, 0, 0, 1, 0); 

  // float camx = 200 * sin(frameCount * 0.001);
  // float camy = 200 * cos(frameCount * 0.001);

  // camera(
  // planter.location.x, planter.location.y + height*0.5, height * 0.5, 
  // planter.location.x + camx, planter.location.y + camy, planter.location.z, 
  // 0, 1, 0);
  hint(ENABLE_DEPTH_TEST);
  noStroke();
  drawGround();

  // predators.birth();
  plants.update();
  plants.draw();

  preys.birth();
  predators.run();
  preys.run();

  for (int i = predators.particles.size()-1; i >= 0; i--) {
    darkenRobotTracks(predators.particles.get(i));
  }


  noLights();
  camera();
  hint(DISABLE_DEPTH_TEST);
  predators.drawEmos();
}

void darkenRobotTracks(Walker bot) {
  tracks.loadPixels();
  for (int i=0; i<30; i++) {
    int x = (int)((bot.location.x / width) * tracks.width + random(-5, 5));
    int y = (int)((bot.location.y / height) * tracks.height + random(-5, 5));

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
